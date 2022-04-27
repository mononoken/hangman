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
