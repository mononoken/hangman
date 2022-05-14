module Saveable
  SAVE_DIR = 'saves'.freeze
  SAVE_FILE = 'save.yaml'.freeze
  SAVE_PATH = "#{SAVE_DIR}/#{SAVE_FILE}".freeze

  def save_game
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)

    File.open(SAVE_PATH, 'w') do |file|
      file.puts YAML.dump(self)
    end
    abort 'Game saved'
  end

  # FIX_ME: This function causes replay issues because of multiple instances of Game running
  def load_game
    YAML.load(File.open(SAVE_PATH, 'r'))
  end

  def prompt_load
    puts "Type 'L' to load. Otherwise enter any key."
    gets.chomp.downcase == 'l'
  end
end
