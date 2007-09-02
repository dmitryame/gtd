class ListController < ApplicationController
  in_place_edit_for :list_item, :description


  def list
    @listItems         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user], 
    session[:list_type], 
    :order             => "sort_order DESC") 
  end

  def activate_list
    @listType          = ListType.find(params[:id])
    session[:list_type] = @listType
  end

  def add_new_item
    maxSortOrder  = ListItem.maximum(:sort_order,  :conditions   => ["user_id = :user_id and list_type_id = :list_type_id", 
      {:user_id => session[:user], :list_type_id => session[:list_type]}])
       
    maxSortOrder  = 0 if(maxSortOrder == nil) 
    maxSortOrder  = maxSortOrder + 1
    newListItem   = ListItem.new(
#    :description  => "new item",
    :user_id      => session[:user],
    :list_type_id => session[:list_type],
    :sort_order   => maxSortOrder,
    :done         => false
    )
    newListItem.save
  end

end
