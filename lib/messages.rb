module Messages
  def intro_game
    "Welcome to Hangman!\n" \
    "Guess the letters in the secret word to win!\n" \
    'Player will guess one letter at a time. ' \
    "Every incorrect guess will count as a penalty.\n" \
    "If the player reaches #{incorrect_limit} penalties, " \
    'they lose and the game is over.'
  end

  def divider
    '---------------'
  end

  def announce_round
    "Round #{@round}"
  end

  def display_incorrect
    "Incorrect guesses (#{@player.incorrect.length} out of #{incorrect_limit}): #{@player.incorrect_str}"
  end

  def round_msgs
    [
      divider,
      announce_round,
      @secret_word.template_string,
      display_incorrect
    ]
  end

  def announce_results
    if incorrect_limit?
      puts 'Game over.'
      puts 'Guess limit reached.'
      puts "The word was #{@secret_word.word}."
    elsif @secret_word.word_complete?
      puts 'Player wins!'
      puts "The word was #{@secret_word.word}."
    end
  end
end
