require 'chronic'

class DongStats
  @@time_intervals = [ :hourly, :daily, :weekly, :monthly, :yearly ]
  @@reset_times = {} 

  # Returns time object for the end of the time period.
  def self.reset_time(timeperiod)
    case timeperiod
    when :hourly
      Chronic.parse('in 1 hour')
    when :daily
      Chronic.parse('tomorrow')
    when :weekly
      Chronic.parse('next Sunday')
    when :monthly
      Chronic.parse('1st day of next month')
    when :yearly
      Chronic.parse('January 1st')
    end
  end

  attr_reader :total,:stats
  @@time_intervals.each do |time_period|
    @@reset_times[time_period] = reset_time(time_period)
    define_method(time_period) { @stats[time_period] }
  end

  def +(number)
     self.add(number)
  end

  def initialize
    @total = 0
    @stats = {}
    @@time_intervals.each do |time_period|
      @stats[time_period] = 0
    end
  end

  def add(number)
    @total += number
    @@time_intervals.each do |time_period|
      @stats[time_period] += number
    end
  end

  def reset_all
    @total = 0
    @@time_intervals.each do |time_period|
      @stats[time_period] = 0
    end
  end

  def flush_expired_period(time_period)
    if Time.now > @@reset_times[time_period]
      @stats[time_period] = 0
      @@reset_times[time_period] = self.class.reset_time(time_period)
    end
  end

  def flush_expired
    @@time_intervals.each do |time_period|
      self.flush_expired_period(time_period)
    end
  end

  def to_s
    "#{@stats.to_s}"
  end

end

