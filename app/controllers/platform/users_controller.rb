class Platform::UsersController < PlatformController
  include Platform::Users::Breadcrumbs

  load_and_authorize_resource

  helper_method :user

  PERMITTED_PARAMS = [
    :name,
    :email,
    :social_name,
    :gender,
    :email_confirmation,
    :document_type,
    :document,
    :password,
    :password_confirmation,
    :education_level,
    :birthday,
    :server,
    :city_id,
    notification_roles: User::NOTIFICATION_ROLES
  ]

  def edit
    super
    flash.alert = I18n.t('user.need_to_change_password') if resource.password_changed_at.nil?
  end

  def update
    if resource.update_attributes(resource_params)
      set_success_flash_notice
      redirect_to edit_platform_user_path(user)
    else
      set_error_flash_now_alert
      render :edit
    end

  end


  # Helper methods

  def user
    resource
  end
end
