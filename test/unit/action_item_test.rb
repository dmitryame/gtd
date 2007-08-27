require File.dirname(__FILE__) + '/../test_helper'

class ActionItemTest < Test::Unit::TestCase
  fixtures :action_items, :list_items

  def test_crud
    doctorsAppointement             = list_items(:doctors_appointement);
    
    pickUpThePhone = action_items(:pick_up_the_phone);
    
    assert pickUpThePhone.save

    pickUpThePhone.description = "push the intercom button"
    assert pickUpThePhone.save
    pickUpThePhone.reload

    assert_equal "push the intercom button", pickUpThePhone.description

    assert pickUpThePhone.destroy

  end

end
