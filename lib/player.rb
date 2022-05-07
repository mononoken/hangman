class Player
  attr_reader :incorrect, :previous_choices
  attr_accessor :game, :guess

  def initialize(game, guess = nil, previous_choices = [], incorrect = [])
    @game = game
    @guess = guess
    @previous_choices = previous_choices
    @incorrect = incorrect
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

  def reset_player_history
    @guess = nil
    @previous_choices.clear
    @incorrect.clear
  end
end
