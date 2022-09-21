class ForgotPasswordMailer < ApplicationMailer
  default from: "socialmedia@socialmedia.com"
  def forgot_password(details)
    @details = details
    mail to: @details[:email], 
          subject: "OTP verification for Social Media #{@details[:user_name]}"
  end
end
