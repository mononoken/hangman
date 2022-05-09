module Saveable
  SAVE_DIR = 'saves'.freeze
  SAVE_FILE = 'save.yaml'.freeze
  SAVE_PATH = "#{SAVE_DIR}/#{SAVE_FILE}".freeze

  def save_game
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)

    File.open(SAVE_PATH, 'w') do |file|
      file.puts YAML.dump(self)
    end
    @game_saved = true
  end

  def load_game
    loaded_game = YAML.load(File.open(SAVE_PATH, 'r'))
    loaded_game.game_loaded = true
    loaded_game.play_game
  end

  def prompt_load
    puts "Type 'L' to load. Otherwise hit any key."
    return unless gets.chomp.downcase == 'l'

    load_game
    @load_file = true
  end
end
