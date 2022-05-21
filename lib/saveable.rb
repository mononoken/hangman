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
    LoadName.list_saves
    YAML.load(File.open(LoadName.new.save_path, 'r'))
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
  end

  def save_path
    "#{SAVE_DIR}/#{save_file}"
  end

  def self.acceptable_chars
    ('a'..'z').to_a + ('0'..'9').to_a + ['_']
  end

  def self.previous_saves
    Dir.glob("#{SAVE_DIR}/*.yaml")
  end

  def request_name
    puts "Please input save file name. Use only letters, numbers, or '_'."
    gets.chomp.downcase
  end

  def valid_name
    name = request_name
    until valid_name?(name)
      name = request_name
      # print variables to see what is broken!
    end
    name
    # name = request_name
    # name = request_name until valid_name?(name)
    # name
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

class LoadName < SaveName
  def self.list_saves
    puts 'Current saves:'
    self.previous_saves.each do |save_path|
      puts save_path.gsub("#{SAVE_DIR}/", '').gsub('.yaml', '')
    end
  end

  def request_name
    puts 'Please pick a save file. Type the save file name as shown in the list.'
    gets.chomp.downcase
  end

  def previous_name?(name)
    self.class.previous_saves.any?(name)
  end
end
