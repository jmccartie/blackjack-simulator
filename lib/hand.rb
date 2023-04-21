class Hand

  attr_accessor :cards

  # Takes array of cards ["A", "3"]
  def initialize(cards=[])
    @cards = cards  
  end

  def total
    total = 0
    num_aces = 0
  
    cards.each do |card|
      if card == 'A'
        num_aces += 1
      elsif ['J', 'Q', 'K'].include?(card)
        total += 10
      else
        total += card.to_i
      end
    end
  
    # Add the aces last to make sure we get the optimal value for them
    num_aces.times do
      if total + 11 <= 21
        total += 11
      else
        total += 1
      end
    end
  
    total
  end 

  def bust?
    total > 21
  end

  def blackjack?
    total == 21 && cards.size == 2
  end

  def first_card_as_int
    Hand::card_to_integer(cards.first)
  end

  def has_ace?
    cards.any? { |card| card == 'A' }
  end

  def has_pair?
    cards.size == 2 && cards.first == cards.last    
  end

  def to_s
    cards.to_s
  end

  def self.card_to_integer(card)
    card.to_i == 0 ? (card == 'A' ? 11 : 10) : card.to_i
  end


end