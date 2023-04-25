# Blackjack Simulator 

This app simulates a looping Blackjack game using basic strategy (`lib/decision.rb`). Run locally with `ruby main.rb`.

Options can be set in `main.rb`, including initial bet, table max, and initial bankroll. 

This app uses the Martingale betting strategy (if you lose, double your bet. if you win, reset your bet to the intitial value). To use a different strategy, modify the `win!` method in `lib/game.rb`.
