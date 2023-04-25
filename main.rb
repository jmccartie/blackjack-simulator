require 'pry'
require_relative './lib/hand'
require_relative './lib/game'
require_relative './lib/decision'
require_relative './lib/deck'

@rounds = 500

g = Game.new(base_bet: 3, max_bet: 500)
# g.bet = 5
@rounds.times do |n|
  g.play! 
end

winnings = g.bankroll.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

puts "Winner! Bankroll $#{winnings}"