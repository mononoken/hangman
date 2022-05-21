# frozen_string_literal: true

# Add saving and loading methods to Game.
module SaveConstants
  SAVE_DIR = 'saves'
  SAVE_FILE = 'save.yaml'
end

module Saveable
  include SaveConstants

  def save_game
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)

    File.open(SaveName.new.save_path, 'w') do |file|
      file.puts YAML.dump(self)
    end
    abort 'Game saved'
  end

  def load_game
    SaveName.previous_saves
    puts 
    YAML.load(File.open(SAVE_PATH, 'r'))
  end

  def prompt_load
    puts "Type 'L' to load. Otherwise enter any key."
    gets.chomp.downcase == 'l'
  end
end

# Represent save file name with proper path formatting.
class SaveName
  include SaveConstants

  def initialize(name = valid_name)
    @name = name
  endg

  def save_path
    "#{SAVE_DIR}/#{save_file}"
  end

  def self.acceptable_chars
    ('a'..'z').to_a + ('0'..'9').to_a + ['_']
  end

  def self.previous_saves
    Dir.glob("#{SAVE_DIR}/*.yaml")
  end

  private

  def request_name
    puts "Please input save file name. Use only letters, numbers, or '_'."
    gets.chomp.downcase
  end

  def valid_name
    name = request_name
    name = request_name until valid_name?(name)
    name
  end

  def save_file
    "#{@name}.yaml"
  end

  def valid_name?(name)
    previous_name?(name) && valid_chars?(name)
  end

  def previous_name?(name)
    self.class.previous_saves.none?(name)
  end

  def valid_chars?(name)
    name.split('').all? { |letter| self.class.acceptable_chars.include? letter }
  end
end
