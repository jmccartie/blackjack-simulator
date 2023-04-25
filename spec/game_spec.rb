RSpec.describe Game do 
  before(:each) do 
    @game = Game.new(base_bet: 3, max_bet: 1_000)
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
      expect(@game.bankroll).to eq 997
    end

    it 'returns a push if both the dealer and player has blackjack' do 
      allow(@game.dealer).to receive(:blackjack?).and_return(true)
      allow(@game.player).to receive(:blackjack?).and_return(true)
      @game.play!
      expect(@game.bankroll).to eq 1_000
    end

    it 'returns a win if we beat the dealer' do 
      player = Hand.new(['K', 'K'])
      dealer = Hand.new(['K', 'K', 'Q'])
      allow(@game).to receive(:deal!).and_return([dealer, player])
      @game.play!
      expect(@game.bankroll).to eq 1_006
    end

    it 'returns a win with 3:2 payout for blackjack' do 
      player = Hand.new(['A', 'K'])
      dealer = Hand.new(['K', 'K', 'Q'])
      allow(@game).to receive(:deal!).and_return([dealer, player])
      @game.play!
      expect(@game.bankroll).to eq 1_007.5
    end

    it 'plays two hands if initial decision is "split"' do 
      # Don't split on K, K
      player = Hand.new(['K', 'K'])
      dealer = Hand.new(['3', 'K'])
      allow(@game).to receive(:deal!).and_return([dealer, player])
      expect(@game).to receive(:results).once
      @game.play!

      # Split on A, A
      player = Hand.new(['A', 'A'])
      dealer = Hand.new(['3', 'K'])
      allow(@game).to receive(:deal!).and_return([dealer, player])
      expect(@game).to receive(:results).twice
      @game.play!
    end
  end

  describe '#win!' do 
    it 'adds the bet and winnings to the bankroll and resets bet' do 
      @game.bet = 50
      @game.win!
      expect(@game.bankroll).to eq 1_100
      expect(@game.bet).to eq 3
    end
  end

  describe '#lose!' do 
    it 'subtracts bet from bankroll and doubles bet' do 
      @game.bet = 50 
      @game.lose!
      expect(@game.bankroll).to eq 950
      expect(@game.bet).to eq 100
    end

    it 'never exceeds the table max' do 
      @game.bankroll = 5000
      @game.bet = 1500
      @game.lose! 
      expect(@game.bet).to eq 1_000
    end
  end

  describe '#results' do 
    before(:each) do 
      allow(@game.dealer).to receive(:blackjack?).and_return(false)
      allow(@game.player).to receive(:blackjack?).and_return(false)
    end

    it 'handles blackjack' do 
      allow(@game.player).to receive(:blackjack?).and_return(true)
      expect(@game).to receive(:blackjack!)
      @game.results(@game.player, @game.dealer)
    end

    it 'handles a dealer bust' do 
      allow(@game.dealer).to receive(:bust?).and_return(true)
      expect(@game).to receive(:win!)
      @game.results(@game.player, @game.dealer)
    end

    it 'handles a player bust' do 
      allow(@game.dealer).to receive(:bust?).and_return(false)
      allow(@game.player).to receive(:bust?).and_return(true)
      expect(@game).to receive(:lose!)
      @game.results(@game.player, @game.dealer)
    end

    it 'handles when dealer total is higher than player' do 
      allow(@game.dealer).to receive(:bust?).and_return(false)
      allow(@game.player).to receive(:bust?).and_return(false)
      allow(@game.dealer).to receive(:total).and_return 21
      allow(@game.player).to receive(:total).and_return 20
      expect(@game).to receive(:lose!)
      @game.results(@game.player, @game.dealer)
    end

    it 'handles a push' do 
      allow(@game.dealer).to receive(:bust?).and_return(false)
      allow(@game.player).to receive(:bust?).and_return(false)
      allow(@game.dealer).to receive(:total).and_return 21
      allow(@game.player).to receive(:total).and_return 21
      expect(@game).to_not receive(:lose!)
      expect(@game).to_not receive(:win!)
      expect(@game).to_not receive(:blackjack!)
      @game.results(@game.player, @game.dealer)
    end

    it 'handles when player total is higher than dealer' do 
      allow(@game.dealer).to receive(:bust?).and_return(false)
      allow(@game.player).to receive(:bust?).and_return(false)
      allow(@game.dealer).to receive(:total).and_return 20
      allow(@game.player).to receive(:total).and_return 21
      expect(@game).to receive(:win!)
      @game.results(@game.player, @game.dealer)
    end
  end

  describe '#blackjack!' do 
    it 'adds bet to bankroll plus 3:2 winnings, and resets bet' do 
      @game.bet = 8
      @game.blackjack!
      expect(@game.bankroll).to eq 1_020
      expect(@game.bet).to eq 3
    end
  end

  describe '#reset_bet!' do 
    it 'resets the bet' do 
      @game.bet = 500
      @game.reset_bet!
      expect(@game.bet).to eq 3
    end
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