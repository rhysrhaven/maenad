require 'cinch'
require 'redis'
require_relative 'user_stats'

class Statistics
  include Cinch::Plugin

  match /stats (.+?) (.+)/
  listen_to :channel

  def listen(m)
    @users[m.user.nick].parse_message(m)    
  end

  def initialize(*args)
    super
    @users = Hash.new { |hash,key| hash[key] = UserStats.new(key) }
  end

  def execute(m, query, nick)
    if @users.key?(nick.downcase)
      case query
      when /dong/
        output = "Dongtackulisness of #{nick} : #{@users[nick].dongstats}"
      when /tot(es|al)/
        output = "Total messages from #{nick} : #{@users[nick].total}"
      end
      m.reply output
    end
  end

end

