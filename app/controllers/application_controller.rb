class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to(:html, :js, :json)
  before_filter :require_login

  protected

  def not_authenticated
    respond_to do |format|
      message =  "Please login before proceeding."
      format.js{
        flash[:error] = message
        render "sessions/new"
      }
      format.html{
        redirect_to new_session_path, :alert => message
      }
    end
  end

  def require_logout
    user = current_user
    if user
      flash[:warn] = "You are already logged in as another user. Please sign out before proceeding!"
      redirect_to root_url
    end
  end

end
