require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_crud
      dmitry = users(:dmitry)
      assert dmitry.save

      dmitry.password = "dmitry1234"
      assert dmitry.save
      dmitry.reload

      assert_equal "dmitry1234", dmitry.password

      assert dmitry.destroy
    end
end
