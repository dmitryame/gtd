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
        :position       => 0,
        :done        => false
    )
    assert inItem.save
    
    inSecondItem = ListItem.new(
        :description => "one more thing to do",
        :user        => users(:dmitry),
        :list_type   => list_types(:in),
        :position       => 1,
        :done        => true
    )
    assert inSecondItem.save
    
    countIn    = ListItem.find_all_by_user_id_and_list_type_id(users(:dmitry), list_types(:in)).size
    countTrash = ListItem.find_all_by_user_id_and_list_type_id(users(:dmitry), list_types(:trash)).size

    assert_equal 3, countIn
    assert_equal 0, countTrash
  end
  
end
