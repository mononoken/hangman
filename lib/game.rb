require_relative 'player'
require_relative 'secret_word'

class Game
  INCORRECT_LIMIT = 6

  # Game
  def initialize
    @player = Player.new
    reset_previous_choice
    reset_rounds
    play_game
  end

  def request_player_guess
    puts 'Player input letter:'
    @player.guess = gets.chomp.downcase until valid_letter?(@player.guess)
  end

  def play_round
    puts divider
    @round += 1
    puts announce_round
    puts @secret_word.word
    puts @secret_word.template_string
    puts display_incorrect
    request_player_guess
    @previous_choice.push(@player.guess)
    check_guess
  end

  def play_game
    puts intro_game
    @secret_word = SecretWord.new
    play_round until end_game?
    announce_results
  end

  def reset_previous_choice
    @previous_choice = []
  end

  def reset_rounds
    @round = 0
  end

  # Rules?
  def end_game?
    incorrect_limit? || @secret_word.word_complete?
  end

  def incorrect_limit?
    @player.incorrect.length == INCORRECT_LIMIT
  end

  def check_guess
    if guess_correct?(@player.guess)
      @secret_word.fill_word_template(@player.guess)
    else
      @player.log_incorrect
    end
  end

  def guess_correct?(guess)
    @secret_word.word_letters.any?(guess)
  end

  def valid_letter?(letter)
    ('a'..'z').to_a.any?(letter) && @previous_choice.none?(letter)
  end

  # Announcer? Message?
  def intro_game
    "Welcome to Hangman!\n" \
    "Guess the letters in the secret word to win!\n" \
    'Player will guess one letter at a time. ' \
    "Every incorrect guess will count as a penalty.\n" \
    "If the player reaches #{INCORRECT_LIMIT} penalties, " \
    'they lose and the game is over.'
  end

  def divider
    '---------------'
  end

  def announce_round
    "Round #{@round}"
  end

  def display_incorrect
    "Incorrect guesses: #{@player.incorrect_str}"
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

  # Word?
end

Game.new
