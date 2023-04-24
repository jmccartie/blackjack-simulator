class Game

  BASE_BET = 3
  
  attr_accessor :player, :dealer, :bet, :status

  def initialize(verbose=false)
    @verbose = verbose
    # @cash 
    @bet = BASE_BET
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

  def play!
    dealer, player = deal!

    if dealer.blackjack? && !player.blackjack?
      puts "Dealer wins with blackjack." if @verbose == true
      self.status = "lose"
      return true
    elsif dealer.blackjack? && player.blackjack?
      puts "Push" if @verbose == true
      self.status = "push"
      return  true
    end

    decision = Decision::decide(player, dealer.first_card_as_int)

    case decision
    when "Hit"
      hit_loop(player)
    when "Double down"
      self.bet = self.bet * 2
      player.cards << @deck.deal_card!
      dealer_turn(dealer)
    when "Stand"
      dealer_turn(dealer)
    when "Split"
      first_hand = Hand.new([player.cards.first])
      hit_loop(first_hand)
      second_hand = Hand.new([player.cards.last])
      hit_loop(second_hand)
      #TODO: run the hit loop on both hands. Figure out how to return a status if there are two wins (or two losses)
      # Maybe make status a win count?
    end

    dealer_turn(dealer)

    if @verbose == true
      puts "Player hand: #{player.cards} (#{player.total}), Dealer hand: #{dealer.cards} (#{dealer.total})"
    end

    # Results!
    if dealer.bust?
      self.status = "win"
      puts "Dealer busts! You win!" if @verbose == true
    elsif player.bust?
      self.status = "lose"
      puts "You bust!"  if @verbose == true
    elsif dealer.total > player.total
      self.status = "lose"
      puts "Dealer wins!" if @verbose == true
    elsif dealer.total == player.total
      self.status = "push"
      puts "Push" if @verbose == true
    else
      self.status = "win"
      puts "You win!" if @verbose == true
    end

    @deck.shuffle_if_needed
  end

  def dealer_turn(dealer)
    while dealer.total < 17
      # return "Bust" if dealer.bust?
      dealer.cards << @deck.deal_card!
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