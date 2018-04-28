require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.in '60s' do
  SidekiqSchedule.instance.time(Time.now+60)
end
