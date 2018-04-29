require "singleton"

class SidekiqSchedule
  include Singleton
  attr_accessor :time

  def initialize
    @time = Time.current + 10
  end
end
