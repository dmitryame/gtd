class ListController < ApplicationController
  in_place_edit_for :list_item, :description
  in_place_edit_for :list_item, :resolution

  in_place_edit_for :action_item, :description

  # in_place_editor_filed helper methods
  def set_list_item_description
    @list_item = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    value = '[enter description]:' + @list_item.id.to_s if value == nil || value.strip == ''
    @list_item.description = value 
    @list_item.save
  end

  def set_list_item_resolution
    @list_item = ListItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    @list_item.resolution = value
    @list_item.save
  end

  def set_action_item_description
    @action_item = ActionItem.find(params[:id])
    value = ERB::Util.h(params[:value])
    value = '[enter description]' if value == nil || value.strip == ''
    @action_item.description = value 
    @action_item.save
    @list_item = @action_item.list_item
  end
  # END in_place_editor_filed helper methods 


  def list
    session[:list_type_id] = ListType.find(:first).id if session[:list_type_id] == nil
    @list_items         = ListItem.find_all_by_user_id_and_list_type_id(
    session[:user_id], 
    session[:list_type_id],
    :order => "position") 
    if @list_items.size > 0
      @list_item = @list_items.first
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
      @list_item.description = @list_item.description + ":" + @list_item.id.to_s
      @list_item.save


      @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      session[:list_item_id] = @list_item.id
    end

    def delete_current_item
      @list_item = ListItem.find(session[:list_item_id])
      if('5'== session[:list_type_id]) # if list_type is trash, then delete it
        if @list_item != nil
          ListItem.destroy(@list_item.id) 
        end
      else # if not trash, then move to trash
        @list_item.list_type_id = 5 # move to trash
        @list_item.save
      end
      
      @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      if @list_items.size > 0
        @list_item = @list_items.first
        session[:list_item_id] = @list_item.id
        @action_items = @list_item.action_items
      else
        @list_item = nil
        @action_items = nil
        session[:list_item_id] = nil
      end
    end

    def move_list_item_to
      @move_to_list_type = params[:move_to_list_type]
      @list_item = ListItem.find(session[:list_item_id])
      @list_item.list_type_id = @move_to_list_type
      @list_item.save
      
      @list_items             = ListItem.find_all_by_user_id_and_list_type_id(
      session[:user_id], 
      session[:list_type_id],
      :order => "position")
      if @list_items.size > 0
        @list_item = @list_items.first
        session[:list_item_id] = @list_item.id
        @action_items = @list_item.action_items
      else
        @list_item = nil
        @action_items = nil
        session[:list_item_id] = nil
      end
    end
    
    def sort_list_items
       @list_items = ListItem.find(params[:sortable_list_items])
       @list_items.each do |list_item|
        list_item.position = params[:sortable_list_items].index(list_item.id.to_s) + 1
        list_item.save
      end
      render :nothing      => true
    end

    def sort_action_items
       @action_items = ActionItem.find(params[:sortable_action_items])
       @action_items.each do |action_item|
        action_item.position = params[:sortable_action_items].index(action_item.id.to_s) + 1
        action_item.save
      end
      render :nothing      => true
    end

    
    def toggle_done
      @list_item = ListItem.find(params[:id])
      if @list_item.done?
        @list_item.done = false
        @list_item.done_at = nil
      else
        @list_item.done = true
        @list_item.done_at = Time.now
      end
      @list_item.save
    end

    def toggle_action_done
      @action_item = ActionItem.find(params[:id])
      if @action_item.done?
        @action_item.done = false
      else
        @action_item.done = true
      end
      @action_item.save
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

    def toggle_action_remind
      @action_item = ActionItem.find(params[:id])
      if @action_item.remind_at != nil
        @action_item.remind_at = nil
      else
        @action_item.remind_at = Time.now
      end
      @action_item.save  
      @list_item = @action_item.list_item
    end

    
    def update_remind_at
      @list_item = ListItem.find(params[:id])
      @list_item.remind_at = params[:remind_at]
      @list_item.save
    end

    def update_action_remind_at
      @action_item = ActionItem.find(params[:id])
      @action_item.remind_at = params[:action_remind_at]
      @action_item.save
      @list_item = @action_item.list_item
    end

    
    def increase_action_nesting_level
      @action_item = ActionItem.find(params[:id])
      if @action_item.nesting_level < 5
        nesting_level = @action_item.nesting_level
        @action_item.nesting_level = nesting_level +1
      end
      @action_item.save
      @list_item = @action_item.list_item
    end

    def decrease_action_nesting_level
      @action_item = ActionItem.find(params[:id])
      if @action_item.nesting_level > 0  
        nesting_level = @action_item.nesting_level
        @action_item.nesting_level = nesting_level -1
      end
      @action_item.save
      @list_item = @action_item.list_item
    end

    def delete_action_item
      @action_item = ActionItem.find(params[:id])      
      @list_item = @action_item.list_item
      ActionItem.delete(params[:id])
    end

    def add_new_action_item
      maxSortOrder  = ActionItem.maximum(:position,  :conditions   => ["list_item_id = :list_item_id", 
        {:list_item_id => session[:list_item_id]}])

        maxSortOrder  = 0 if(maxSortOrder == nil) 
        maxSortOrder  = maxSortOrder + 1

         @action_items = ActionItem.find_all_by_list_item_id(
          session[:list_item_id],
          :order => "position")

        if @action_items != nil && @action_items.size >0
          nesting_level = @action_items.last.nesting_level  
        else
          nesting_level = 0
        end
        
        @action_item   = ActionItem.new(
        :description  => '[New Item]',
        :list_item_id      => session[:list_item_id],
        :position   => maxSortOrder,
        :nesting_level    => nesting_level,
        :done         => false
        )
        @action_item.save

        @action_items.push @action_item

        @list_item = @action_item.list_item

      end

    
  end
