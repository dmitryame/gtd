class ListItem < ActiveRecord::Base
  belongs_to :list_type
  belongs_to :user
  acts_as_list :scope=>:user
  has_many  :action_items, :dependent => :destroy, :order => :position # this will do the cascade delete
  
  validates_presence_of :user_id, :list_type_id, :position
  
end
