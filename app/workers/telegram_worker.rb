class TelegramWorker
  include Sidekiq::Worker

  ERROR_CHANCE = 5

  def perform(message_id)
    time = 130.second
    message = Message.find(message_id)
    message.attempt += 1

    if rand(0..100) < ERROR_CHANCE
      TelegramWorker.perform_at(time.from_now, message_id)
    else
      message.was_sent = true
    end

    message.save!
  end
end
