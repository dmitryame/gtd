require File.dirname(__FILE__) + '/../test_helper'

class ListItemTest < Test::Unit::TestCase
  fixtures :list_items, :users, :list_types
  def test_crud
    dmitry                          = users(:dmitry)
    doctorsAppointement             = list_items(:doctors_appointement);
    assert doctorsAppointement.save

    doctorsAppointement.description = "dentist appointement"
    assert doctorsAppointement.save
    doctorsAppointement.reload

    assert_equal "dentist appointement", doctorsAppointement.description

    assert doctorsAppointement.destroy

  end
  
  def test_lists_for_user
    
    inItem = ListItem.new(
        :description => "new thing to do",
        :user        => users(:dmitry),
        :list_type   => list_types(:in),
        :order       => 0,
        :done        => false
    )
    assert inItem.save
    
    inSecondItem = ListItem.new(
        :description => "one more thing to do",
        :user        => users(:dmitry),
        :list_type   => list_types(:in),
        :order       => 1,
        :done        => true
    )
    assert inSecondItem.save
    
    User.find()
    
  end
  
end
