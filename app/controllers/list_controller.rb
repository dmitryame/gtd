class ListController < ApplicationController
  def list
  end

  def activate_list
    @listType = ListType.find(params[:id])
    (session[:listType] ||= Hash.new)[@listType.id] = @listType.id
  end


end
