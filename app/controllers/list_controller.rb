class ListController < ApplicationController
  in_place_edit_for :list_item, :description
  in_place_edit_for :list_item, :resolution

  def set_list_item_description
    @listItem = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    value = '[enter description]' if value == nil || value.strip == ''
    @listItem.description = value 
    @listItem.save
  end

  def set_list_item_resolution
    @listItem = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    @listItem.resolution = value
    @listItem.save
  end


  def list
    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
    @listItems         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    if @listItems.size > 0
      session[:list_item_id] = @listItems.first.id
    else
      session[:list_item_id] = nil
    end
  end

  def activate_list
    session[:list_type_id] = params[:id]
    @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    if @listItems.size >0
      @listItem = @listItems.first
      session[:list_item_id] = @listItem.id 
    else
      @listItem = nil
      session[:list_item_id] = nil
    end
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
      ListItem.delete(session[:list_item_id]) if session[:list_item_id]
      @listItems             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      if @listItems.size > 0
        @listItem = @listItems.first
        session[:list_item_id] = @listItem.id
      else
        @listItem = nil
        session[:list_item_id] = nil
      end
    end

    def sort
       @listItems = ListItem.find(params[:all_list_items])
       @listItems.each do |list_item|
        list_item.position = params[:all_list_items].index(list_item.id.to_s) + 1
        list_item.save
      end
      render :nothing      => true
    end
    
    def toggle_done
      @listItem = ListItem.find(params[:id])
      if @listItem.done?
        @listItem.done = false
      else
        @listItem.done = true
      end
      @listItem.save
    end
    
    def toggle_remind
      @listItem = ListItem.find(params[:id])
      if @listItem.remind_at != nil
        @listItem.remind_at = nil
      else
        @listItem.remind_at = Time.now
      end
      @listItem.save  
    end
    
    def update_remind_at
      @listItem = ListItem.find(params[:id])
      @listItem.remind_at = params[:remind_at]
      @listItem.save
    end
  end
