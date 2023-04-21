require 'pry'
require_relative 'hand'
require_relative 'game'
require_relative 'decision'
require_relative 'deck'


@wins = 0
@losses = 0
@rounds = 1_000_000 

g = Game.new(verbose=false)
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