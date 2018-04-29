class WhatsUpWorker < ApplicationWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find(message_id)
    message.attempts += 1
    time = SidekiqSchedule.instance.time
    error_code = rand(0..100)

    if error_code < ERROR_CHANCE
      WhatsUpWorker.perform_at(time, message.id)
    else
      message.was_sent = true
    end

    message.save!
  end
end
