class Game
  
  attr_accessor :player, :dealer, :bet, :bankroll
  attr_reader :base_bet, :max_bet

  def initialize(base_bet:, max_bet: )
    @bankroll = @max_bet = max_bet
    @bet = @base_bet = base_bet
    @deck = Deck.new
    @player = Hand.new
    @dealer = Hand.new
  end


  def deal!
    [player, dealer].each {|hand| hand.cards = [] }
    
    2.times do 
      player.cards << @deck.deal_card!
      dealer.cards << @deck.deal_card!
    end

    if @verbose == true
      puts "Player cards = #{player}"
      puts "Dealer cards = #{dealer}"
    end

    return dealer, player
  end

  def win!    
    self.bankroll += (self.bet * 2)
    reset_bet!
  end

  def lose!
    self.bankroll -= self.bet
    raise "You ran out of money. Last bet: #{self.bet}." if self.bankroll <= 0
    # reset_bet!
    self.bet = [(self.bet * 2), max_bet].sort[0] #martingale. Double last bet unless table max
  end

  def blackjack!
    self.bankroll += (self.bet + (self.bet * 1.5))
    reset_bet!
  end

  def reset_bet!
    self.bet = self.base_bet
  end

  def play!
    dealer, player = deal!

    if dealer.blackjack? && !player.blackjack?
      lose!
      return true
    elsif dealer.blackjack? && player.blackjack?
      # push. do nothing to status, but return immediately
      return  true
    end

    decision = Decision::decide(player, dealer.first_card_as_int)

    case decision
    when "Hit"
      hit_loop(player)
    when "Double down"
      self.bet = self.bet * 2
      player.cards << @deck.deal_card!
    when "Stand"
      # do nothing
    when "Split"
      first_hand = Hand.new([player.cards.first])
      hit_loop(first_hand)
      second_hand = Hand.new([player.cards.last])
      hit_loop(second_hand)
    end

    dealer_turn(dealer)

    # Results!
    if first_hand 
      results(first_hand, dealer)
      results(second_hand, dealer)
    else 
      results(player, dealer)
    end
  end

  def dealer_turn(dealer)
    while dealer.total < 17
      dealer.cards << @deck.deal_card!
    end
  end

  def results(player, dealer)
    if player.blackjack? && !dealer.blackjack?
      blackjack!
    elsif dealer.bust?
      win!
    elsif player.bust?
      lose!
    elsif dealer.total > player.total
      lose!
    elsif dealer.total == player.total
      # Push. Do nothing.
    else
      win!
    end
  end


  private 
  def hit_loop(hand)
    hand.cards << @deck.deal_card!
    while !["Stand", "Bust"].include?(Decision::decide(hand, dealer.first_card_as_int))
      puts "(Hit loop) #{Decision::decide(hand, dealer.first_card_as_int)}"  if @verbose == true
      hand.cards << @deck.deal_card!
    end
    hand
  end


end