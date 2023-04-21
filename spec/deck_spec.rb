RSpec.describe Deck do 

  before(:each) do 
    @deck = Deck.new 
  end

  describe '#initialize' do 
    it 'creates a deck of cards based on how many decks to include' do
      expect(Deck.new.cards.size).to be 53 # There's a cut card in there
      expect(Deck.new(3).cards.size).to be 157
    end
  end

  describe '#shuffle_if_needed' do 
    it 'shuffles the deck if needed' do 
      @deck.instance_variable_set(:@cut_card_found, true)
      expect(@deck.instance_variable_get(:@cut_card_found)).to be true
      expect(@deck).to receive(:create_new_deck).with(1)
      
      expect(@deck.shuffle_if_needed).to be true
      expect(@deck.instance_variable_get(:@cut_card_found)).to be false
    end

    it 'does nothing if not needed' do 
      expect(@deck.instance_variable_get(:@cut_card_found)).to be false
      expect(@deck.instance_variable_get(:@cut_card_found)).to be false
    end
  end

  describe '#deal_card!' do 
    it 'deals a card' do 
      @deck.cards = ["A", "K"]

      expect(@deck.deal_card!).to eq "A"
      expect(@deck.cards.size).to be 1
    end

    it 'sets cut_card to true if CUT is next' do
      expect(@deck.instance_variable_get(:@cut_card_found)).to be false
      @deck.cards = ["CUT", "A", "K"]

      expect(@deck.deal_card!).to eq "A"
      expect(@deck.instance_variable_get(:@cut_card_found)).to be true
    end

  end

  describe '#create_new_deck' do 
    it 'returns a deck of cards' do 
      new_deck = @deck.send(:create_new_deck, 1)
      expect(new_deck.size).to eq 53
      expect(new_deck).to include("CUT")
      expect(new_deck).to include("A")
      expect(new_deck).to include("3")
    end
  end

  describe '#place_cut_card' do 
    it 'places a cut card randomly in the deck, between the first and last 15 cards' do
      deck = (1..52).to_a.map(&:to_s)
      expect(deck).to_not include "CUT"
      Deck.new.send(:place_cut_card, deck)
      expect(deck).to include "CUT"
      expect(deck.take(15)).to_not include "CUT"
      expect(deck.last(15)).to_not include "CUT"
    end

  end


end