# frozen_string_literal: true

# Constants for SaveName and LoadName.
module SaveConstants
  SAVE_DIR = 'saves'
end

# Allow game to save games and load from these saved games.
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

  def save_file(name = @name)
    "#{name}.yaml"
  end

  def save_path(file = save_file)
    "#{SAVE_DIR}/#{file}"
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

  def valid_chars?(name)
    name.split('').all? { |letter| self.class.acceptable_chars.include? letter }
  end

  def valid_name?(name)
    valid_chars?(name) && (available_name?(name) || overwrite?(name))
  end

  def available_name?(name)
    file_path = save_path(save_file(name))
    self.class.previous_saves.none?(file_path)
  end

  def overwrite?(name)
    return if available_name?(name)

    puts "Save name, '#{name}', has been previously used."
    puts 'Do you wish to overwrgite previous save? (y/n)'
    gets.chomp.downcase == 'y'
  end

  def valid_name
    name = request_name
    name = request_name until valid_name?(name)
    name
  end
end

# Represent load file name with proper path formatting.
class LoadName < SaveName
  def initialize(name = valid_name)
    puts "Load '#{name}' initiated!"
    super
  end

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
    file_path = save_path(save_file(name))
    self.class.previous_saves.any?(file_path)
  end

  def valid_name?(name)
    valid_chars?(name) && previous_name?(name)
  end
end
