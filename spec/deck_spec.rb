RSpec.describe Deck do 

  before(:each) do 
    @deck = Deck.new 
  end

  describe '#initialize' do 
    it 'creates a deck of cards based on how many decks to include' do
      expect(Deck.new.cards.size).to be 52
      expect(Deck.new(3).cards.size).to be 156
    end
  end

  describe '#deal_card!' do 
    it 'deals a card' do 
      @deck.cards = ["A", "K"]

      expect(@deck.deal_card!).to eq "A"
      expect(@deck.cards.size).to be 1
    end

    it 'makes a new deck if there are no more cards' do 
      @deck.cards = []
      expect(@deck.cards).to be_empty
      @deck.deal_card!
      expect(@deck.cards).to_not be_empty
    end

  end

  describe '#create_new_deck' do 
    it 'returns a deck of cards' do 
      new_deck = @deck.send(:create_new_deck, 1)
      expect(new_deck.size).to eq 52
      expect(new_deck).to include("A")
      expect(new_deck).to include("3")
    end
  end

end