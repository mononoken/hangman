# frozen_string_literal: true

# Add saving and loading methods to Game.
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

  def load_game
    YAML.load(File.open(SAVE_PATH, 'r'))
  end

  def prompt_load
    puts "Type 'L' to load. Otherwise enter any key."
    gets.chomp.downcase == 'l'
  end
end

class SaveName
  def save_path
    saves = self.saves
    save_name = gets.chomp.downcase until saves.none?(save_name) && ('a'..'z').to_a.all? { |letter| save_name.include? letter }
    save_file = "#{save_name}.yaml"
    save_path = "#{SAVE_DIR}/#{save_file}"
  end

  def self.saves
    Dir.glob("#{SAVE_DIR}/*.yaml")
  end

  def self.acceptable_chars
    ('a'..'z').to_a + ('0'..'9').to_a + ['_']
  end

  def check_name(name)
    saves.none?(save_name) && name.split('').all? { |letter| acceptable_chars.include? letter }
  end
end
