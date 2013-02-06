class UsersController < ApplicationController

  skip_before_filter :require_login, :only => [:new, :create, :activate]
  before_filter :require_logout, :only => [:new, :create, :activate]

  respond_to :html, :json, :js

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      message = "Signed up! Please go to your email account and click on the activation link. Don't forget to check your spam folder in case you don't see the activation email."
      if @user.save
        Mailer.new.activation_needed_email @user.email, @user.activation_token
        format.html { redirect_to new_session_path }
      else
        format.html {
          flash[:error] = @user.errors.full_messages[0]
          redirect_to :action=> :new
        }
      end
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      Mailer.new.activation_success_email @user
      redirect_to(new_session_path, :notice => 'Successfully activated account.')
    else
      not_authenticated
    end
  end


  def show
    @user = current_user
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@user) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@user) }
      end
    end
  end


  ###############<private methods>#######################
  private

  def user_params
    params[:user].permit(:email, :password, :password_confirmation)
  end

end
