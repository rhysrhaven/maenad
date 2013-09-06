require 'chronic'

class DongStats
  ## Class Stuff
  @@time_intervals = [ :hourly, :daily, :weekly, :monthly, :yearly ]

  ## Instance of the Class Stuff
  attr_reader :total,:stats
  @@time_intervals.each do |time_period|
    define_method(time_period) { @stats[time_period] }
  end

  def initialize(total = 0, stats = {})
    @total = total
    @stats = stats
    @reset_times = {} 
    @@time_intervals.each do |time_period|
      @stats[time_period] = 0 if @stats.length != @@time_intervals.length
      @reset_times[time_period] = reset_time(time_period)
      flush_expired_period(time_period)
    end
  end

  # Returns time object for the end of the time period.
  def reset_time(timeperiod)
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
  
  def +(number)
     add(number)
  end

  def add(number)
    @total += number
    flush_expired
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
    if Time.now > @reset_times[time_period]
      @stats[time_period] = 0
      @reset_times[time_period] = reset_time(time_period)
    end
  end

  def flush_expired
    @@time_intervals.each do |time_period|
     flush_expired_period(time_period)
    end
  end

  def to_s
    flush_expired
    "#{@stats.to_s}"
  end

  def to_json(*a)
    {
      "json_class" => self.class.name,
      "total"      => @total,
      "stats"      => @stats
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o['total'], o['stats'])
  end

end

