class UserMailer < ActionMailer::Base
  default from: "torqueboxtest@yahoo.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    @host = "localhost:8080"
    @url  = "http://" + @host +  "/password_resets/#{user.reset_password_token}/edit"
    mail(:to => user.email, :subject => "Your password has been reset")
  end

  def activation_needed_email(email, activation_token)
    @email = email
    @host = "localhost:8080"
    @url  = "http://" + @host + "/users/#{activation_token}/activate"
    mail(:to => email, :subject => "Please activate your account")
  end

  def activation_success_email(user)
    @user = user
    @url  = new_session_path
    mail(:to => user.email, :subject => "Welcome to gayathris.com!")
  end

end
