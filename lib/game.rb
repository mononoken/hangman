class Player
  attr_reader :incorrect
  attr_accessor :guess

  def initialize
    @guess = nil
    @incorrect = []
  end

  def log_incorrect
    @incorrect.push(@guess)
  end

  def incorrect_str
    @incorrect.join(', ')
  end
end

class Game 
  attr_reader :word_letters, :word_template
  attr_writer :word_template

  INCORRECT_LIMIT = 6

  def initialize
    @random_word = random_word
    @word_letters = @random_word.split('')
    @word_template = Array.new(@word_letters.length, '_')
    @player = Player.new
    @previous_choice = []
    @round = 0
  end

  def play_round
    puts divider
    @round += 1
    puts announce_round
    puts @random_word #DELETE OR CHEAT
    puts template_string(@word_template)
    puts display_incorrect
    request_player_guess
    @previous_choice.push(@player.guess)
    check_guess
  end

  def play_game
    puts intro_game
    play_round until incorrect_limit? || word_complete?
    if incorrect_limit?
      puts 'Game over.'
      puts 'Guess limit reached.'
      puts "The word was #{@random_word}."
    elsif word_complete?
      puts 'Player wins!'
      puts "The word was #{@random_word}."
    end
  end

  def intro_game
    "Welcome to Hangman!\n" \
    'Guess the letters in the secret word one letter at a time.'
  end

  def divider
    '---------------'
  end

  def request_player_guess
    puts 'Player input letter:'
    @player.guess = gets.chomp.downcase until valid_letter?(@player.guess)
  end

  def incorrect_limit?
    @player.incorrect.length == INCORRECT_LIMIT
  end

  def word_complete?
    @word_template.none?('_')
  end

  def check_guess
    if guess_correct?(@player.guess)
      fill_word_template(@player.guess)
    else
      @player.log_incorrect
    end
  end

  def guess_correct?(guess)
    @word_letters.any?(guess)
  end

  def fill_word_template(guess)
    @word_letters.each_with_index do |letter, index|
      @word_template[index] = guess if letter == guess
    end
  end

  def display_incorrect
    "Incorrect guesses: #{@player.incorrect_str}"
  end

  def valid_letter?(letter)
    ('a'..'z').to_a.any?(letter) && @previous_choice.none?(letter)
  end

  def announce_round
    "Round #{@round}"
  end

  def extract_dictionary
    File.readlines(File.expand_path('../dic/google-10000-english-no-swears.txt', File.dirname(__FILE__)), chomp: true)
  end

  def word_criteria?(word)
    word.length.between?(5, 12)
  end

  def filtered_word_list
    extract_dictionary.select { |word| word_criteria?(word) }
  end

  def random_word
    filtered_word_list.sample
  end

  def template_string(word_template)
    word_template.join(' ')
  end
end

Game.new.play_game