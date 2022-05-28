# frozen_string_literal: true

# Include the string statements for Game.
module Messages
  def intro_msg
    'Welcome to Hangman!'
  end

  def rules
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

  def player_choice_instructions
    "Player input letter (or type 'save' to save):"
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

  def end_game_msg
    'Thank you for playing!'
  end

  def load_opt
    "Type 'L' to load. Otherwise enter any key."
  end

  def save_instructions
    "Please input save file name. Use only letters, numbers, or '_'."
  end

  def load_instructions
    'Please pick a save file. Type the save file name as shown in the list.'
  end

  def save_exists_error(name)
    [
      "Save name, '#{name}', has been previously used.",
      'Do you wish to overwrite previous save? (y/n)'
    ]
  end
end
