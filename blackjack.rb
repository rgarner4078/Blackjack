=begin
  WIN CONDITION: Player recieves Blackjack (drew total value of 21), or the dealer busts (drew over 21). If the player draws 5 cards without busting then the player automatically wins.
  NUMBER OF PLAYERS: One
  RULES: The game begins with the player drawing two cards. Then the player is giving the option to hit (draw another card) or stay (keep their total and end all turns). 
          In the event of a hit, the player will draw another card and if they do not bust or get Blackjack, the dealer will automatically draw another card.
          When the player stays the dealer will continue to draw cards until the dealer has a hand greater or equal than the player's (the dealer wins if there is a tie), or busts, or gets blackjack.
          The dealer MUST DRAW until they have a hand of at least 17.
          In the event that the player's hand is lower than the dealers, the player will be forced to draw.
  NOTE ABOUT ACES: Aces will always count for 11 towards a total hand value, unless the total value of the hand plus 11 is greater than 21, then the ace counts as 1.
=end

def hit(players_turn, hand, deck, cards_drawn)
  card_choosen = deck.first
  card_face = card_choosen[0]
  card_value = card_choosen[1]
  if card_value == 11 && hand + 11 <= 21
    card_value = 11
  elsif card_value == 11 && hand + 11 > 21
    card_value = 1
  end
  hand = hand + card_value
  if players_turn == true
    puts "=> Player drew #{card_face}, Player's hand at #{hand}"
    cards_drawn += 1
  else
    puts "=> Dealer drew #{card_face}, Dealer's hand at #{hand}"
  end
  deck.shift
  return hand, deck, cards_drawn
end

def check_for_bust_or_win(players_turn, hand, cards_drawn)
  if hand == 21 && players_turn == true
    puts "=> BLACKJACK! PLAYER WINS!"
    return true
  elsif hand > 21 && players_turn == true
    puts "=> BUST! PLAYER LOSES"
    return true
  elsif hand == 21 && players_turn == false
    puts "=> BLACKJACK! DEALER WINS"
    return true
  elsif hand > 21 && players_turn == false
    puts "=> BUST! DEALER LOSES!"
    return true
  elsif players_turn == true && cards_drawn == 5
    puts "=> PLAYER DREW 5 CARDS! PLAYER WINS!"
    return true 
  else
    return false
  end
end

def rotate_turns(players_hand, dealers_hand, deck, cards_drawn)
  result = false
  player_stays = false
  until result != false
    if player_stays == false
      if players_hand <= dealers_hand && dealers_hand >= 17
        players_hand, deck, cards_drawn = hit(true, players_hand, deck, cards_drawn)
      else
        players_hand, deck, player_stays, cards_drawn = players_turn(players_hand, deck, cards_drawn)
      end
    end
    result = check_for_bust_or_win(true, players_hand, cards_drawn)
    if result == false 
      if player_stays == true && dealers_hand >= players_hand && dealers_hand >= 17
        puts "=> Player stays at #{players_hand}, Dealer's hand at #{dealers_hand}, DEALER WINS"
        result = true
      else
        dealers_hand, deck, cards_drawn = dealers_turn(dealers_hand, deck, players_hand, cards_drawn)
        result = check_for_bust_or_win(false, dealers_hand, cards_drawn)
      end
    end
  end
end

def players_turn(hand, deck, cards_drawn)
  hit_again = nil
  until hit_again == "h" || hit_again == "s"
    puts "=> Hit or stay? (h/s)"
    hit_again = gets.chomp.downcase
  end
  if hit_again == "h"
    hand, deck, cards_drawn = hit(true, hand, deck, cards_drawn)
    return hand, deck, false, cards_drawn
  elsif hit_again == "s"
    puts "=> Player stays at #{hand}"
    return hand, deck, true, cards_drawn
  end
end

def dealers_turn(hand, deck, players_hand, cards_drawn)
  if hand < 21 && players_hand > hand
    hand, deck, cards_drawn = hit(false, hand, deck, cards_drawn)
  end
  return hand, deck, cards_drawn
end

def blackjack()
  clubs = {"1 of Clubs" => 1, "2 of Clubs" => 2, "3 of Clubs" => 3, "4 of Clubs" => 4, "5 of Clubs" => 5, "6 of Clubs" => 6, "7 of Clubs" => 7, "8 of Clubs" => 8, "9 of Clubs" => 9, "Jack of Clubs" => 10,  "Queen of Clubs" => 10, "King of Clubs" => 10, "Ace of Clubs" => 11}
  diamonds = {"1 of Diamonds" => 1, "2 of Diamonds" => 2, "3 of Diamonds" => 3, "4 of Diamonds" => 4, "5 of Diamonds" => 5, "6 of Diamonds" => 6, "7 of Diamonds" => 7, "8 of Diamonds" => 8, "9 of Diamonds" => 9, "Jack of Diamonds" => 10,  "Queen of Diamonds" => 10, "King of Diamonds" => 10, "Ace of Diamonds" => 11}
  hearts = {"1 of Hearts" => 1, "2 of Hearts" => 2, "3 of Hearts" => 3, "4 of Hearts" => 4, "5 of Hearts" => 5, "6 of Hearts" => 6, "7 of Hearts" => 7, "8 of Hearts" => 8, "9 of Hearts" => 9, "Jack of Hearts" => 10,  "Queen of Hearts" => 10, "King of Hearts" => 10, "Ace of Hearts" => 11}
  spades = {"1 of Spades" => 1, "2 of Spades" => 2, "3 of Spades" => 3, "4 of Spades" => 4, "5 of Spades" => 5, "6 of Spades" => 6, "7 of Spades" => 7, "8 of Spades" => 8, "9 of Spades" => 9, "Jack of Spades" => 10,  "Queen of Spades" => 10, "King of Spades" => 10, "Ace of Spades" => 11}
  deck = clubs.merge(diamonds).merge(hearts).merge(spades)
  deck = Hash[deck.to_a.shuffle]

  players_hand = 0
  dealers_hand = 0
  cards_drawn = 0

  puts "--- BLACKJACK ---"
  puts "=> Player is delt two cards.."
  players_hand, deck = hit(true, players_hand, deck, cards_drawn)
  players_hand, deck = hit(true, players_hand, deck, cards_drawn)
  if check_for_bust_or_win(true, players_hand, cards_drawn) == false
    rotate_turns(players_hand, dealers_hand, deck, cards_drawn)
  end
end

blackjack()