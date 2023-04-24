class Deck

  attr_accessor :cards

  def initialize(deck_count=1)
    @deck_count = deck_count
    @cards = create_new_deck(deck_count)
  end

  def deal_card!
    if @cards.empty?
      @cards = create_new_deck(@deck_count)
    end

    @cards.shift
  end


  private 
  def create_new_deck(deck_count)
    values = (2..10).map(&:to_s) + ['A', 'K', 'Q', 'J']

    # Create empty deck
    deck = []

    # Loop through each suit and value, creating a card and adding it to the deck
    deck_count.times do 
      4.times {|n| deck << values } # 4 suits
    end

    deck.flatten!
    deck.shuffle
  end

end