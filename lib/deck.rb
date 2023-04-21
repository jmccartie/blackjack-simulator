class Deck

  attr_accessor :cards

  def initialize(deck_count=1)
    @deck_count = deck_count
    @cards = create_new_deck(deck_count)
    @cut_card_found = false
  end

  def shuffle_if_needed
    if @cut_card_found == true 
      @cards = create_new_deck(@deck_count)
      @cut_card_found = false
      return true
    end
    return false
  end


  def deal_card!
    card = @cards.shift

    if card == "CUT"
      @cut_card_found = true
      card = @cards.shift
    end

    card
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
    place_cut_card(deck)
    deck.shuffle
  end

  # Place the cut card between cards 15 and 37 
  def place_cut_card(deck)
    placement = rand(15..(deck.size-15))
    deck.insert(placement, "CUT")
  end


end