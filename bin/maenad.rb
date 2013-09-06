require 'cinch'
require_relative '../lib/statistics/statistics'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.servercentral.net"
    c.nick     = "maenad"
    c.channels = ["#loltesting"]
    c.plugins.plugins = [Statistics]
  end
end

bot.start
