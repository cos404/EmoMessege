require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '60s' do
  SidekiqSchedule.instance.time=(Time.now+60)
end
