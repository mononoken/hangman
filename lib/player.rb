class Player
  attr_reader :incorrect, :previous_choices
  attr_accessor :game, :guess

  def initialize(game, guess = nil, previous_choices = nil, incorrect = nil)
    @game = game
    if @game.load_file == true
      @guess = guess
      @previous_choices = previous_choices
      @incorrect = incorrect
    else
      @guess = nil
      @previous_choices = []
      @incorrect = []
    end
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
end
