require 'cinch'
require_relative '../lib/user_stats'

class Statistics 
  include Cinch::Plugin
  
  match /stats (.+)/
  listen_to :channel

  def listen(m)
    @users[m.user.nick].dongstats + m.message.scan("dong").count
  end

  def initialize(*args)
    super
    @users = Hash.new { |hash,key| hash[key] = UserStats.new(key) }
  end

  def execute(m, nick)
    if @users.key?(nick)
      output = @users[nick].dongstats
      m.reply "Dongtackulisness of #{nick} : #{output}"
    end
  end

end

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.servercentral.net"
    c.nick     = "maenad"
    c.channels = ["#chicago"]
    c.plugins.plugins = [Statistics]
  end
end

bot.start
