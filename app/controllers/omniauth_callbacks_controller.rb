class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user
      redirect_to platform_root_path, notice: t('devise.omniauth_callbacks.user.success')
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, alert: t('devise.omniauth_callbacks.user.error')
    end
  end

  def failure
    redirect_to new_user_registration_url, alert: t('devise.omniauth_callbacks.user.error')
  end
end
