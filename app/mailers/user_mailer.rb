class UserMailer < ActionMailer::Base
  default :from => "admin@pinterials.com"

  def notification_email(recieve_user,send_user)
  	@recieveUser = recieve_user
  	@sendUser = send_user
    @url  = "http://example.com/login"
    mail(:to => @recieveUser.email, :subject => "Notification email")
  end

end
