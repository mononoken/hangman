Understand the problem:
Write a program that plays the game hangman. The game will initialize with a player and the computer. The rules of the game will be explained to the player. Then, the computer will choose a random word from a given dictionary. The player will give letter guesses and receive feedback for each guess. The game will end when either the player completes the word or runs out of incorrect guesses.

Plan:
Does the program have an interface?
The game will play on terminal. It will show the number of letter slots for the word to the player in the form of:
_ _ _ _ _
It will also display the 'hangman'. This could be in the form of an image or as simply the number of incorrect guesses over the number left.

What inputs will your program have?
Player input of letter guesses

What's the desired output?
A smooth game where the player can make guesses, receive feedback, and avoid any bugs that would interupt the game.

What are the steps necessary for the desired output? (pseudocode)

* #start_game:
* Puts #intro to game and #rules
* Game loads dictionary of words from txt file and stores as #word_list.
* Game filters #word_list for game criteria
  - Criteria: between 5 and 12 characters long
* Game uses enumerable to select a random word from the dictionary array.
* Game stores word as #word_letters
* Game initializes #word_template array which has length equal to #word_letters. 

* #play_round:
* Game puts #word_template on command line in form of '_ _ _ _'
* Game puts request for #player_input
* Player gives #player_input in form of letter
* Game checks if #player_input.valid?
* player_input.valid? if #player_input is not in #guesses, must be in 'abc...z'
  - If valid, game will set #player_input as #valid_guess
  - If invalid, game will reject input, puts 'Invalid input', and request #player_input again.
* Game checks each item in #word_array to see if it matches #valid_guess.
  - If valid, fill the letter in on word_template
  - If invalid, increment #invalid_guess_count
* Until the following... play_round
  ? word_template == word_array
    - if true, end game and puts 'Player wins!'
  - guess_quantity == guess_limit
    - if true, end game and announce 'Player loses.'

- Need to create game function to save progress and load from save

Possible classes:
- Word
- Player
- Rules


Divide and conquer: