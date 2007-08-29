class UserController < ApplicationController
  def signin
    if request.post?
      user = User.find(:first, :conditions => ['login = ?', params[:login]])
      if user.blank? ||
        Digest::SHA256.hexdigest(params[:password] + user.password_salt) != user.password_hash
        session[:user] = nil
        flash[:notice] = "Login or Password invalid";
      else
        session[:user] = user.id
        redirect_to :action => session[:intended_action], :controller => session[:intended_controller]
      end
      
    end
  end
  def register
    if request.post?
      session[:user] = user.id
      redirect_to :action => session[:intended_action], :controller => session[:intended_controller]
    end
  end
end