module AuthorizedController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_enabled_user

  end


  # private

  private

  def authenticate_enabled_user
    authenticate_user!

    if current_user.disabled?
      sign_out
      redirect_to new_user_session_path, alert: t('devise.failure.disabled')
    end
  end
end
