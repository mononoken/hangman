require_relative 'player'
require_relative 'secret_word'
require_relative 'messages'
require_relative 'saveable'

require 'yaml'

class Game
  include Messages
  include Saveable

  INCORRECT_LIMIT = 6

  def initialize
    puts intro_msg
    if prompt_load
      puts load_success_msg
      load_game.play_game
    else
      @player = Player.new
      new_game
      play_game
    end
  end

  def new_game
    reset_game_values
    puts rules
  end

  def reset_rounds
    @round = 1
  end

  def reset_game_values
    create_secret_word
    reset_rounds
    @player.reset_player_history
  end

  def request_player_guess
    guess = nil
    until valid_letter?(guess) || guess == 'save'
      puts "Player input letter (or type 'save' to save):"
      guess = gets.chomp.downcase
    end
    save_game if guess == 'save'
    @player.guess = guess if valid_letter?(guess)
  end

  def check_guess
    if guess_correct?(@player.guess)
      @secret_word.fill_word_template(@player.guess)
    else
      @player.log_incorrect
    end
  end

  def player_turn
    request_player_guess
    @player.log_previous_choice
    check_guess
  end

  def play_round
    puts round_msgs
    player_turn
    @round += 1
  end

  def play_rounds
    play_round until end_game?
    announce_results
  end

  def play_game
    run_game = true
    while run_game
      play_rounds
      if replay_game?
        run_game = true
        reset_game_values
      else
        run_game = false
      end
    end
    puts end_game_msg
  end

  def create_secret_word
    @secret_word = SecretWord.new
  end

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
    ('a'..'z').to_a.any?(letter) && @player.previous_choices.none?(letter)
  end

  def incorrect_limit
    INCORRECT_LIMIT
  end

  def replay_game?
    puts 'Play again? (y/n)'
    replay = gets.chomp.downcase until replay == 'y' || replay == 'n'
    replay == 'y'
  end
end

Game.new
