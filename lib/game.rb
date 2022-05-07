require_relative 'player'
require_relative 'secret_word'
require_relative 'messages'

require 'yaml'

class Game
  include Messages

  attr_reader :load_file

  INCORRECT_LIMIT = 6

  SAVE_DIR = 'saves'.freeze
  SAVE_FILE = 'save.yaml'.freeze
  SAVE_PATH = "#{SAVE_DIR}/#{SAVE_FILE}".freeze

  def initialize
    @game_saved = nil
    prompt_load
    return if @load_file == true

    @player = Player.new(self)
    new_game
    play_game
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

  def new_game
    puts intro_game
    create_secret_word
    reset_rounds
    @player.reset_player_history
  end

  def play_round
    @round += 1
    puts round_msgs
    player_turn
  end

  def play_game
    play_round until end_game? || @game_saved == true
    announce_results
  end

  def create_secret_word
    @secret_word = SecretWord.new
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
    ('a'..'z').to_a.any?(letter) && @player.previous_choices.none?(letter)
  end

  def incorrect_limit
    INCORRECT_LIMIT
  end

  def save_game
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)

    File.open(SAVE_PATH, 'w') do |file|
      file.puts YAML.dump(self)
    end
    @game_saved = true
  end

  def load_game
    loaded_game = YAML.load(File.open(SAVE_PATH, 'r'))
    loaded_game.play_game
  end

  def prompt_load
    puts "Type 'L' to load. Otherwise hit any key."
    return unless gets.chomp.downcase == 'l'

    load_game
    @load_file = true
  end
end
