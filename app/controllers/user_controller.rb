class UserController < ApplicationController
  
  def signin
    if request.post?
      print params[:name]
      print params[:password] 
      user = User.authenticate(params[:name], params[:password])
      if user.blank?
          session[:user_id] = nil
        flash[:notice] = "Name or Password invalid";
      else
        session[:user_id] = user.id
        redirect_to :action => "list", :controller => "list"
      end
    end
  end
  
  def logout
    session[:user_id]      = nil
    session[:list_type_id] = nil
    redirect_to :action => "list", :controller => "list"
  end  
  
  def register
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      session[:user_id] = @user.id
      redirect_to :action => "list", :controller => "list"
    end
  end
 
end