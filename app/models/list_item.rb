class ListItem < ActiveRecord::Base
  belongs_to :list_type
  belongs_to :user
  has_many  :action_items
  
  validates_presence_of :description, :user_id, :list_type_id, :order
  
end
