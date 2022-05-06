class Player
  attr_reader :incorrect, :previous_choices
  attr_accessor :guess

  def initialize
    @guess = nil
    @previous_choices = []
    @incorrect = []
  end

  def log_incorrect
    @incorrect.push(@guess)
  end

  def incorrect_str
    @incorrect.join(', ')
  end

  def log_previous_choice
    @previous_choices.push(@guess)
  end

  def reset_previous_choices
    @previous_choices = []
  end
end
