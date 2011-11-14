class UserMailer < ActionMailer::Base
  default from: "no-reply@kirin.chubachi.net"

  def welcome_email(user)
    @user = user
    @url  = "http://zxt.chubachi.net/"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
