RSpec.describe Game do 
  before(:each) do 
    @game = Game.new
  end

  describe '#deal!' do 
    it 'gives out 2 cards to the player and dealer both' do 
      expect(@game.player.cards).to eq []
      expect(@game.dealer.cards).to eq []
      @game.deal!
      expect(@game.player.cards.size).to eq 2
      expect(@game.dealer.cards.size).to eq 2
    end

  end

  describe '#play!' do 
    it 'returns a loss if dealer has blackjack' do 
      allow(@game.dealer).to receive(:blackjack?).and_return(true)
      allow(@game.player).to receive(:blackjack?).and_return(false)
      @game.play!
      expect(@game.status).to eq "lose"
    end

    it 'returns a push if both the dealer and player has blackjack' do 
      allow(@game.dealer).to receive(:blackjack?).and_return(true)
      allow(@game.player).to receive(:blackjack?).and_return(true)
      @game.play!
      expect(@game.status).to eq "push"
    end

    it 'plays two hands if initial decision is "split"'
  end

  describe '#dealer_turn' do 
    it 'does nothing if dealer total is 17' do 
      dealer = Hand.new(['K', '7'])
      @game.dealer_turn(dealer)
      expect(dealer.cards).to eq ['K', '7']
    end

    it 'deals cards until decision is to stand or bust' do 
      dealer = Hand.new(['K', '6'])
      allow_any_instance_of(Deck).to receive(:deal_card!).and_return('J')
      @game.dealer_turn(dealer)
      expect(dealer.cards).to eq ['K', '6', 'J']
    end

  end
end 