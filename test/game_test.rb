gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/game'

class GameTest < MiniTest::Test
  def test_word_list_extraction
    expected =
      ''
    assert_equal expected, Game.new.get_word_list
  end
