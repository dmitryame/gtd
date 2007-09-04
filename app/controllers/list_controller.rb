class ListController < ApplicationController

  def list
    @listItems         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id], 
    :order             => "position DESC") 

    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
  end

  def activate_list
    session[:list_type_id] = ListType.find(params[:id]).id
  end

  def add_new_item
    maxSortOrder  = ListItem.maximum(:position,  :conditions   => ["user_id = :user_id and list_type_id = :list_type_id", 
      {:user_id => session[:user_id], :list_type_id => session[:list_type_id]}])
       
    maxSortOrder  = 0 if(maxSortOrder == nil) 
    maxSortOrder  = maxSortOrder + 1

    
    newListItem   = ListItem.new(
    :user_id      => session[:user_id],
    :list_type_id => session[:list_type_id],
    :position   => maxSortOrder,
    :done         => false
    )
    newListItem.save
  end

end
