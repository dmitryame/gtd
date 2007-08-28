class UserController < ApplicationController
  def signin
    if request.post?
      user = User.find(:first, :conditions => ['login = ?', params[:login]])
      if user.blank? ||
        Digest::SHA256.hexdigest(params[:password] + user.password_salt) != user.password_hash
        session[:user] = nil
        raise "Login or Password invalid"
      end
      session[:user] = user.id
      redirect_to :action => session[:intended_action], :controller => session[:intended_controller]
    end
  end
end
