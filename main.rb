require 'pry'
require_relative './lib/hand'
require_relative './lib/game'
require_relative './lib/decision'
require_relative './lib/deck'


@wins = 0
@losses = 0
@rounds = 10_000 

g = Game.new(false)
g.bet = 5
@rounds.times do |n|
  print "." if n % 1_000 == 0
  g.play! 
  case g.status
  when "win"
    @wins += 1
  when "lose"
    @losses += 1
  end
end


puts "\nWins = #{@wins} (#{(@wins.to_f/@rounds.to_f)*100}%)"