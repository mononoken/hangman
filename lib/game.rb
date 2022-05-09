require_relative 'player'
require_relative 'secret_word'
require_relative 'messages'
require_relative 'saveable'

require 'yaml'

class Game
  include Messages
  include Saveable
  attr_accessor :game_loaded

  INCORRECT_LIMIT = 6

  def initialize
    @game_saved = nil
    @game_loaded = nil
    prompt_load
    return if @load_file == true

    @player = Player.new(self)
    new_game
    play_game
  end

  def new_game
    puts intro_game
    reset_game_values
  end

  def reset_rounds
    @round = 0
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
    @round += 1 unless @game_loaded == true
    @game_loaded = nil
    puts round_msgs
    player_turn
  end

  def play_game
    play_round until end_game? || @game_saved == true

    if @game_saved == true
      return puts 'Game saved'
    else
      announce_results
      while replay_game?
        replay_game
      end
    end
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

  def reset_game_values
    create_secret_word
    reset_rounds
    @player.reset_player_history
  end

  def replay_game?
    puts 'Play again? (y/n)'
    replay = gets.chomp.downcase
    until replay == 'y' || replay == 'n'
      replay = gets.chomp.downcase
    end
    replay == 'y'
  end

  def replay_game
    reset_game_values
    self.play_game
  end
end

Game.new
