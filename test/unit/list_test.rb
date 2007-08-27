require File.dirname(__FILE__) + '/../test_helper'

class ListTest < Test::Unit::TestCase
  fixtures :lists
  def test_loadall
    list = List.find(:all)
    assert_equal list.size, 6
  end
end
