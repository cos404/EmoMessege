class MessageController < ApplicationController

  def create
    render status: :unauthorized if !authorized(message_params[:token])

    if @user
      @message = message_params[:message]

      @ids = []
      process_message(message_params[:telegram], :telegram)
      process_message(message_params[:whats_up], :whats_up)
      process_message(message_params[:viber], :viber)

      render json: @ids, status: :complete
    end
  end

  private

  def message_params
    params.permit(:token, :message, :telegram, :whats_up, :viber, telegram: [], whats_up: [], viber: [])
  end

  def process_message(recipient, service)
    return if recipient.blank?

    if recipient.is_a? Array
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
end