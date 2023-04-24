module Decision

  def self.decide(hand, dealer_card)
    return "Bust" if hand.bust?
    return "Blackjack" if hand.blackjack?
    dealer_card = Hand::card_to_integer(dealer_card)
    if hand.has_pair? && self.split_pair?(hand.cards, dealer_card) # Pair spliting
      return "Split"
    elsif hand.has_ace? && hand.cards.size == 2 # Soft totals
      return self.soft_total(hand, dealer_card)
    else
      return self.hard_total(hand.total, dealer_card)
    end
  end


  private

  def self.hard_total(hand_value, dealer_card)
    case hand_value
    when 17..21
      "Stand"
    when 13..16
      dealer_card >= 7 ? "Hit" : "Stand"  
    when 12
      dealer_card.between?(4,6) ? "Stand" : "Hit"
    when 11
      "Double down"
    when 10
      dealer_card >= 10 ? "Hit" : "Double down"
    when 9
      (dealer_card == 9 || dealer_card >= 7) ? "Hit" : "Double down"
    else
      "Hit"
    end
  end

  def self.split_pair?(hand, dealer_card)
    return true if hand.first == "A" || hand.first == "8"

    case Hand::card_to_integer(hand.first)
    when 10 
      false
    when 9
      (dealer_card == 7 || dealer_card >= 10) ? false : true
    when 7
      dealer_card >= 8 ? false : true
    when 6
      (dealer_card == 2 || dealer_card >= 7) ? false : true
    when 4..5
      false
    when 2..3
      dealer_card.between?(4,7) ? true : false
    end 
  end


  def self.soft_total(hand, dealer_hand)    
    card = (hand.cards - ["A"]).first.to_i
    # binding.pry
    case card
    when 9
      "Stand"
    when 8
      dealer_hand == 6 ? "Double down" : "Stand"
    when 7
      dealer_hand.between?(2,8) ? "Stand" : "Hit"
    when 6
      dealer_hand.between?(3,6) ? "Double down" : "Hit"
    when 4..5
      dealer_hand.between?(4,6) ? "Double down" : "Hit"
    when 2..3
      dealer_hand.between?(5,6) ? "Double down" : "Hit"
    else
      binding.pry
      raise "Soft total error"
    end
  end



end