require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_crud
      dmitry = users(:dmitry)
      assert dmitry.save

      dmitry.password = "dmitry1234"
      password_hash = dmitry.password_hash
      assert dmitry.save
      dmitry.reload

      assert_equal password_hash, dmitry.password_hash

      assert dmitry.destroy
    end
end
