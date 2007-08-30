# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_gtd_session_id'
  before_filter :check_authentication, :except => [:signin, :register]
  
  def check_authentication
    unless session[:user]
      redirect_to :controller => "user", :action => "signin"
    end
  end
end
