class ListController < ApplicationController
  in_place_edit_for :list_item, :description
  def set_list_item_description
    @listItem = ListItem.find(params[:id])
    @listItem.description = ERB::Util.h(params[:value])
    @listItem.save
  end


  def list
    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
    @listItems         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    session[:list_item_id] = @listItems.first.id
  end

  def activate_list
    session[:list_type_id] = params[:id]
    @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
  end
  
  def activate_list_item
    session[:list_item_id] = params[:id]
    @listItem = ListItem.find_all_by_id_and_user_id(
    session[:list_item_id],
    session[:user_id]
    ).first
  end

  def add_new_item
    maxSortOrder  = ListItem.maximum(:position,  :conditions   => ["user_id = :user_id and list_type_id = :list_type_id", 
      {:user_id => session[:user_id], :list_type_id => session[:list_type_id]}])

      maxSortOrder  = 0 if(maxSortOrder == nil) 
      maxSortOrder  = maxSortOrder + 1

      @listItem   = ListItem.new(
      :description  => '[New Item]',
      :user_id      => session[:user_id],
      :list_type_id => session[:list_type_id],
      :position   => maxSortOrder,
      :done         => false
      )
      @listItem.save

      @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      session[:list_item_id] = @listItem.id
    end

    def delete_current_item
      ListItem.delete(session[:list_item_id])
       @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
       session[:user_id], 
       session[:list_type_id],
       :order => "position")
       @listItem = @listItems.first
      session[:list_item_id] = @listItem.id
    end

    def sort
       @listItems = ListItem.find(params[:all_list_items])
       puts @listItems.size
       @listItems.each do |list_item|
        list_item.position = params[:all_list_items].index(list_item.id.to_s) + 1
        list_item.save
      end
      render :nothing      => true
    end
  end
