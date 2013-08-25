require_relative 'dong_stats'

class UserStats
  attr_accessor :name,:dongstats

  def initialize(username)
    @name = username
    @dongstats = DongStats.new
  end
  
end
