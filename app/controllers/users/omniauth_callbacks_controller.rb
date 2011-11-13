# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def open_id
    open_id_general('open_id')
  end

  def google
    open_id_general('google')
  end

  private

  def open_id_general(kind)
    @user = User.find_for_open_id_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.#{kind}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
