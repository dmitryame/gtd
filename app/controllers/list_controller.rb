class ListController < ApplicationController

  def list
    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
    @listItems         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 

    session[:list_items] = @listItems        
  end

  def activate_list
    session[:list_type_id] = ListType.find(params[:id]).id
    @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    session[:list_items] = @listItems        
  end

  def add_new_item
    maxSortOrder  = ListItem.maximum(:position,  :conditions   => ["user_id = :user_id and list_type_id = :list_type_id", 
      {:user_id => session[:user_id], :list_type_id => session[:list_type_id]}])

      maxSortOrder  = 0 if(maxSortOrder == nil) 
      maxSortOrder  = maxSortOrder + 1

      newListItem   = ListItem.new(
      :description  => 'Click To Change Description',
      :user_id      => session[:user_id],
      :list_type_id => session[:list_type_id],
      :position   => maxSortOrder,
      :done         => false
      )
      newListItem.save

      @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      
      session[:list_items] = @listItems        
      
    end

    def sort
      @listItems  = session[:list_items]        
      @listItems.each do |list_item|
        list_item.position = params['all_list_items'].index(list_item.id.to_s) + 1
        list_item.save
      end
      render :nothing      => true

    end
  end
