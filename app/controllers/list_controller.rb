class ListController < ApplicationController
  in_place_edit_for :list_item, :description
  in_place_edit_for :list_item, :resolution

  def set_list_item_description
    @list_item = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    value = '[enter description]' if value == nil || value.strip == ''
    @list_item.description = value 
    @list_item.save
  end

  def set_list_item_resolution
    @list_item = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    @list_item.resolution = value
    @list_item.save
  end


  def list
    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
    @list_items         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    if @list_items.size > 0
      session[:list_item_id] = @list_items.first.id
    else
      session[:list_item_id] = nil
    end
  end

  def activate_list
    session[:list_type_id] = params[:id]
    @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    if @list_items.size >0
      @list_item = @list_items.first
      session[:list_item_id] = @list_item.id 
    else
      @list_item = nil
      session[:list_item_id] = nil
    end
  end
  
  def activate_list_item
    session[:list_item_id] = params[:id]
    @list_item = ListItem.find_all_by_id_and_user_id(
    session[:list_item_id],
    session[:user_id]
    ).first
  end

  def add_new_item
    maxSortOrder  = ListItem.maximum(:position,  :conditions   => ["user_id = :user_id and list_type_id = :list_type_id", 
      {:user_id => session[:user_id], :list_type_id => session[:list_type_id]}])

      maxSortOrder  = 0 if(maxSortOrder == nil) 
      maxSortOrder  = maxSortOrder + 1

      @list_item   = ListItem.new(
      :description  => '[New Item]',
      :user_id      => session[:user_id],
      :list_type_id => session[:list_type_id],
      :position   => maxSortOrder,
      :done         => false
      )
      @list_item.save

      @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      session[:list_item_id] = @list_item.id
    end

    def delete_current_item
      ListItem.delete(session[:list_item_id]) if session[:list_item_id]
      @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      if @list_items.size > 0
        @list_item = @list_items.first
        session[:list_item_id] = @list_item.id
      else
        @list_item = nil
        session[:list_item_id] = nil
      end
    end

    def sort
       @list_items = ListItem.find(params[:all_list_items])
       @list_items.each do |list_item|
        list_item.position = params[:all_list_items].index(list_item.id.to_s) + 1
        list_item.save
      end
      render :nothing      => true
    end
    
    def toggle_done
      @list_item = ListItem.find(params[:id])
      if @list_item.done?
        @list_item.done = false
      else
        @list_item.done = true
      end
      @list_item.save
    end
    
    def toggle_remind
      @list_item = ListItem.find(params[:id])
      if @list_item.remind_at != nil
        @list_item.remind_at = nil
      else
        @list_item.remind_at = Time.now
      end
      @list_item.save  
    end
    
    def update_remind_at
      @list_item = ListItem.find(params[:id])
      @list_item.remind_at = params[:remind_at]
      @list_item.save
    end
  end
