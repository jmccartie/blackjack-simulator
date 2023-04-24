RSpec.describe Decision do 

  before(:each) do 
    @hand = Hand.new
  end


  describe 'blackjack' do 
    it 'returns blackjack if hand is already blackjack' do 
      @hand.cards = ["K", "A"]
      expect(Decision::decide(@hand, "A")).to eq "Blackjack"
    end
  end

  describe 'bust' do 
    it 'returns bust if hand is over 21' do 
      @hand.cards = ["K", "K", "K"]
      expect(Decision::decide(@hand, "A")).to eq "Bust"
    end
  end

  describe 'stand' do 
    it 'returns stand if correct play' do 
      @hand.cards = ["K", "K"]
      expect(Decision::decide(@hand, "3")).to eq "Stand"
    end
  end

  describe 'double down' do 
    it 'returns double down if correct play' do 
      @hand.cards = ["8", "3"]
      expect(Decision::decide(@hand, "3")).to eq "Double down"
    end
  end

  describe 'hit' do 
    it 'returns hit if correct play' do 
      @hand.cards = ["K", "2"]
      expect(Decision::decide(@hand, "8")).to eq "Hit"
    end
  end

  describe 'split' do 
    it 'returns split if correct play' do 
      @hand.cards = ["A", "A"]
      expect(Decision::decide(@hand, "3")).to eq "Split"
    end
  end

  describe 'soft_total' do 
    it 'returns double down if A,8 against 6' do 
      @hand.cards = ["A", "8"]
      expect(Decision::decide(@hand, "6")).to eq "Double down"
    end 

    it 'returns hit if A,7 against 10' do 
      @hand.cards = ["A", "7"]
      expect(Decision::decide(@hand, "10")).to eq "Hit"
    end
  end


end