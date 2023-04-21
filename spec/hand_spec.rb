RSpec.describe Hand do 

  before(:each) do 
    @hand = Hand.new
  end

  describe "#total" do 
    it "returns the total of a hand" do 
      @hand.cards = ["2", "5"]
      expect(@hand.total).to be 7
      @hand.cards = ["K", "10"]
      expect(@hand.total).to be 20
    end 

    it "correctly returns the value of aces" do
      
      @hand.cards = ["A", "9"]
      expect(@hand.total).to be 20

      @hand.cards = ["A", "A"] 
      expect(@hand.total).to be 12

      @hand.cards = ["A", "A", "A", "A"]
      expect(@hand.total).to be 14
    end 
  end 

  describe '#bust?' do 
    it 'returns true if the hand is busted' do 
      @hand.cards = ["K", "K", "2"]
      expect(@hand.bust?).to be true
      @hand.cards = ["2", "2"]
      expect(@hand.bust?).to be false 
    end 
  end

  describe '#blackjack?' do 
    it 'returns true if the total is exactly 21 and there are two cards' do 
      @hand.cards = ["A", "K"]
      expect(@hand.blackjack?).to be true
      @hand.cards = ["A", "5"]
      expect(@hand.blackjack?).to be false
    end

    it 'returns false if total is not 21 or if there are more than two cards' do 
      @hand.cards = ["10", "8", "3"]
      expect(@hand.total).to be 21
      expect(@hand.blackjack?).to be false
      @hand.cards = ["2", "3"]
      expect(@hand.total).to be 5
      expect(@hand.blackjack?).to be false
    end
  end

  describe '#first_card_as_int' do 
    it 'calls class method with the first card' do 
      @hand.cards = ["A"]
      expect(Hand).to receive(:card_to_integer).with("A")
      @hand.first_card_as_int
    end
  end

  describe '#has_ace?' do 
    it 'returns true if any cards in the hand is an ace' do 
      @hand.cards = ["A"]
      expect(@hand.has_ace?).to be true
      @hand.cards = ["K"]
      expect(@hand.has_ace?).to be false
    end
  end

  describe '#has_pair?' do 
    it 'returns true if there are two cards and they are the same' do
      @hand.cards = ["A", "A"]
      expect(@hand.has_pair?).to be true
      @hand.cards = ["A", "K"]
      expect(@hand.has_pair?).to be false
    end
  end

  describe '#to_s' do 
    it 'returns a string representation of cards' do 
      @hand.cards = ["A"]
      expect(@hand.to_s).to eq '["A"]'
    end
  end

  describe '.card_to_integer' do 
    it 'returns an integer' do 
      expect(Hand::card_to_integer('2')).to be 2
    end

    it 'returns 11 for an Ace' do 
      expect(Hand::card_to_integer('A')).to be 11
    end

    it 'returns 10 for a face card' do 
      expect(Hand::card_to_integer('K')).to be 10
    end
  end


end
