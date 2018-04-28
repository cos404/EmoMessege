class TelegramWorker < ApplicationWorker
  include Sidekiq::Worker

  ERROR_CHANCE = 50

  def perform(message_id)
    message = Message.find(message_id)
    message.attempt += 1
    time = SidekiqSchedule.instance.time

    if rand(0..100) < ERROR_CHANCE
      TelegramWorker.perform_at(time, message.id)
    else
      message.was_sent = true
    end

    message.save!
  end
end
