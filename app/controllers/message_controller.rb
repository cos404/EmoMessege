class MessageController < ApplicationController
  before_action :set_params, only: [:create]
  REG_DELAY = 10

  def create
    return if not authorized?(message_params[:token])
    return if not validates_params?
    return if duplicate_message?
    @ids = []

    process_message(@telegram, :telegram)
    process_message(@whats_up, :whats_up)
    process_message(@viber, :viber)

    render json: {registered_messages: @ids}, status: :ok
  end

  private

  def message_params
    params.permit(:token, :message, :telegram, :whats_up, :viber, telegram: [], whats_up: [], viber: [])
  end

  def set_params
    @message = message_params[:message]
    @telegram = message_params[:telegram]
    @whats_up = message_params[:whats_up]
    @viber = message_params[:viber]
  end

  def process_message(recipient, service)
    return if recipient.blank?

    if recipient.is_a?(Array)
      recipient.each do |recipient_name|
        message = Message.create(
          message: @message,
          recipient: recipient_name,
          service: service,
          user: @user)
        load_worker(message.id, service)
        @ids << message.id
      end
    else
      message = Message.create(
        message: @message,
        recipient: recipient,
        service: service,
        user: @user)
      load_worker(message.id, service)
      @ids << message.id
    end
  end

  def validates_params?
    @errors = Hash.new
    @errors.store(:message, "Message can't be blank!") if @message.blank?

    if @telegram.blank? && @whats_up.blank? && @viber.blank?
      @errors.store(:recipient, "Recipient can't be blank!")
    end

    if !@errors.blank?
      render json: @errors, status: :bad_request
      return false
    end

    true
  end

  def duplicate_message?
    recipients = [@telegram, @whats_app, @viber].flatten.select {|e| not e.nil?}

    duplicate_message = Message.select(:id).where(
      user_id: @user.id,
      recipient: recipients,
      created_at: Time.now-REG_DELAY..Time.now,
      message: @message)

    if recipients.length == duplicate_message.length
      render json:
        {duplicate_messages: "Duplicate message! Wait #{REG_DELAY} seconds or send another message."},
        status: :conflict
      return true
    end

    false
  end

  def load_worker(id, type)
    time = SidekiqSchedule.instance.time
    TelegramWorker.perform_at(time, id)  if type == :telegram
    ViberWorker.perform_at(time, id)     if type == :viber
    WhatsUpWorker.perform_at(time, id)   if type == :whats_up
  end
end