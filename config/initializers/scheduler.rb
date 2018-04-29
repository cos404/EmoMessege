require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '60s' do
  SidekiqSchedule.instance.time=(Time.current+60)
end
