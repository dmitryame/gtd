class ActionItem < ActiveRecord::Base
  belongs_to :list_item
  acts_as_list :scope=>:list_item
end
