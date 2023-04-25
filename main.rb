require 'pry'
require_relative './lib/hand'
require_relative './lib/game'
require_relative './lib/decision'
require_relative './lib/deck'

@rounds = 500

g = Game.new(base_bet: 25, max_bet: 5000)
# g.bet = 5
@rounds.times do |n|
  g.play! 
end


puts "Winner! Bankroll $#{g.bankroll}"