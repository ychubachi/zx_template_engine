class UserMailer < ActionMailer::Base
  default from: "no-reply@kirin.chubachi.net"

  def welcome_email(user)
    @user = user
    @url  = "http://zxt.chubachi.net/"
    mail(:to => user.email, :subject => "Zipped XML Template Engine")
  end
end
