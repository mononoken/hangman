class Game 
  def initialize
  end

  def get_word_list
    contents = File.read(File.expand_path('../dic/google-10000-english-no-swears.txt', File.dirname(__FILE__)))
    puts contents
  end
end

Game.new.get_word_list
