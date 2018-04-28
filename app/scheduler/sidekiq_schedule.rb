require 'singleton'

class SidekiqSchedule
  include Singleton

  def initialize
    @time = Time.now + 300
  end

  def time(time)
    @time = time
  end

  def time
    @time
  end
end