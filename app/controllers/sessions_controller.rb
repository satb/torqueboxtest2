class SessionsController < ApplicationController

  skip_before_filter :require_login, :only => [:new, :create]
  before_filter :require_logout, :only => [:new, :create]

  def new
  end

  def create
    user = login(params[:session][:email], params[:session][:password])
    if user
      @return_url = session[:return_to] || new_secret_path
      session.delete(:return_to)
    else
      @return_url = request.url
    end
    respond_to do |format|
      format.js
      format.html{
        if user
          redirect_to @return_url, :notice=>"Logged In!"
        else
          flash.now.alert = "Email or password was invalid"
          render :new
        end
      }
    end
  end


  def destroy
    logout
    respond_to do |format|
      message = "Signed Out successfully."
      format.js {flash[:notice] = message}
      format.html {redirect_to root_url, notice: message}
    end
  end


end
