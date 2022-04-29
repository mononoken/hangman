class SecretWord
  attr_reader :word, :word_letters, :word_template

  def initialize
    @word = random_word
    @word_letters = @word.split('')
    @word_template = Array.new(@word_letters.length, '_')
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

  def fill_word_template(guess)
    @word_letters.each_with_index do |letter, index|
      @word_template[index] = guess if letter == guess
    end
  end

  def template_string(word_template)
    word_template.join(' ')
  end
end
