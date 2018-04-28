class MessageController < ApplicationController
  before_action :set_params, only: [:create]


  def create
    return if !authorized?(message_params[:token])
    return if !validates_params?
    @ids = []

    process_message(@telegram, :telegram)
    process_message(@whats_up, :whats_up)
    process_message(@viber, :viber)

    render json: @ids, status: :ok

  end

  private

  def message_params
    params.permit(:token, :message, :telegram, :whats_up, :viber, telegram: [], whats_up: [], viber: [])
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
        @ids << message.id
      end
    else
      message = Message.create(
        message: @message,
        recipient: recipient,
        service: service,
        user: @user)
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

    return true
  end

  def set_params
    @message = message_params[:message]
    @telegram = message_params[:telegram]
    @whats_up = message_params[:whats_up]
    @viber = message_params[:viber]
  end
end