require 'json'
require_relative 'dong_stats'

class UserStats

  attr_accessor :name, :total, :dongstats

  def initialize(username, total = 0, dongstats = nil)
    @name = username
    @total = total
    @dongstats = dongstats ||= DongStats.new
  end

  def parse_message(m)
    @total += 1
    dongcount = m.message.scan("dong").count
    @dongstats + dongcount if dongcount > 0
  end

  def to_json(*a)
    {
      "json_class" => self.class.name,
      "name"       => @name,
      "total"      => @total,
      "dongstats"  => @dongstats.to_json
    }.to_json(*a)
  end

  def self.json_create(o)
    dongstats = JSON.load(o['dongstats'])
    new(o['name'],o['total'],dongstats)
  end
  
end
