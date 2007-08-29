class UserController < ApplicationController
  
  def signin
    if request.post?
      print params[:name]
      print params[:password] 
      user = User.authenticate(params[:name], params[:password])
      if user.blank?
        session[:user] = nil
        flash[:notice] = "Name or Password invalid";
      else
        session[:user] = user.id
        redirect_to :action => session[:intended_action], :controller => session[:intended_controller]
      end
    end
  end
  
  def register
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
    end
  end
 
end