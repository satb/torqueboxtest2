#this class is needed to have the always_background method. Doing it directly on ActionMailer subclasses
#will cause some problems with Marshal.dump deep inside Torquebox.
class Mailer
  include TorqueBox::Messaging::Backgroundable

  def reset_password_email(user)
    mail = UserMailer.reset_password_email user
    mail.deliver
  end

  #using user param here is erroring out in torquebox saying no "undefined method `utc' for String"
  def activation_needed_email(email, activation_token)
    mail = UserMailer.activation_needed_email email, activation_token
    mail.deliver
  end

  def activation_success_email(user)
    mail = UserMailer.activation_success_email user
    mail.deliver
  end


  always_background :mail_password_reset_instructions, :activation_needed_email, :activation_success_email, :order_customer_email, :order_admin_email

end