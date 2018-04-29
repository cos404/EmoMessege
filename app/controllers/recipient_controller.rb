class RecipientController < ApplicationController
  before_action :set_params, only: [:show]

  def show
    return if not authorized?(recipient_params[:token])
    return if not validates_params?

    if not @telegram.blank?
      service = :telegram
      recipient = @telegram
    end

    if not @whats_up.blank?
      service = :whats_up
      recipient = @whats_up
    end

    if not @viber.blank?
      service = :viber
      recipient = @viber
    end

    recipientStats = Message
    .select(
      'recipient',
      'SUM(attempt) AS attempts_count',
      'COUNT(id) AS messages_count',
      'ROUND(100-100.0*COUNT(message)/SUM(attempt), 2) AS failure_rate')
    .group(:recipient)
    .where(
      service: service,
      recipient: recipient)
    .as_json(except: :id)

    if(recipientStats.blank?)
      render  json: {error: "Recipient not found! Change platform or recipient id."},
              status: :unprocessable_entity
      return
    else
      render  json: recipientStats[0],
              status: :ok
    end
  end

  private

  def recipient_params
    params.permit(:token, :telegram, :whats_up, :viber)
  end

  def set_params
    @telegram = recipient_params[:telegram]
    @whats_up = recipient_params[:whats_up]
    @viber = recipient_params[:viber]
  end

  def validates_params?
    services = [@telegram, @whats_up, @viber].compact
    if services.count != 1
      render  json: {error: "Must be one recipient!"},
              status: :unprocessable_entity
      return false
    end

    true
  end

end