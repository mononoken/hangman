require_relative 'player'
require_relative 'secret_word'
require_relative 'messages'

class Game
  include Messages

  INCORRECT_LIMIT = 6

  def initialize
    @player = Player.new
    reset_previous_choice
    reset_rounds
    play_game
  end

  def request_player_guess
    until valid_letter?(@player.guess)
      puts 'Player input letter:'
      @player.guess = gets.chomp.downcase
    end
  end

  def check_guess
    if guess_correct?(@player.guess)
      @secret_word.fill_word_template(@player.guess)
    else
      @player.log_incorrect
    end
  end

  def player_guess
    request_player_guess
    @previous_choice.push(@player.guess)
    check_guess
  end

  def play_round
    @round += 1
    puts round_msgs
    player_guess
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

  # Rules
  def end_game?
    player_loses? || player_wins?
  end

  def incorrect_limit?
    @player.incorrect.length == INCORRECT_LIMIT
  end

  def player_wins?
    @secret_word.word_complete? == true
  end

  def player_loses?
    incorrect_limit? == true
  end

  def guess_correct?(guess)
    @secret_word.word_letters.any?(guess)
  end

  def valid_letter?(letter)
    ('a'..'z').to_a.any?(letter) && @previous_choice.none?(letter)
  end

  def incorrect_limit
    INCORRECT_LIMIT
  end
end

Game.new
