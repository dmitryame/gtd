require File.dirname(__FILE__) + '/../test_helper'

class ListItemTest < Test::Unit::TestCase
  fixtures :list_items, :users
def test_crud
  dmitry = users(:dmitry)
  doctorsAppointement = list_items(:doctors_appointement);
  assert doctorsAppointement.save

  doctorsAppointement.description = "dentist appointement"
  assert doctorsAppointement.save
  doctorsAppointement.reload

  assert_equal "dentist appointement", doctorsAppointement.description

  assert doctorsAppointement.destroy
  
end
end
