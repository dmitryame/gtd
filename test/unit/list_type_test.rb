require File.dirname(__FILE__) + '/../test_helper'

class ListTypeTest < Test::Unit::TestCase
  fixtures :list_types, :users
  def test_loadall
    listTypes = ListType.find(:all)
    assert_equal listTypes.size, 6
  end
  
end
