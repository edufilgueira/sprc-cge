class RegistrationsController < Devise::RegistrationsController
  include Registrations::Breadcrumbs
  include ::SingleAuthenticationGuard

  #before_action :store_user_location!, if: :storable_location?


  PERMITTED_PARAMS = [
    :document,
    :document_type,
    :email,
    :email_confirmation,
    :name,
    :password,
    :password_confirmation,
    :person_type,
    :education_level,
    :birthday,
    :server,
    :city_id
  ]


  # def after_sign_up_path_for(_resource)
  #   new_platform_ticket_path(ticket_type: ticket_type)
  # end

  # def after_sign_in_path_for(_resource)
  #   platform_root_path
  # end

  # Private

  private

  def sign_up_params
    user_params = params.require(:user).permit(PERMITTED_PARAMS)

    # só permite registro de usuários :user (cidadãos)
    # resource.user_type = :user
    user_params[:user_type] = :user
    user_params
  end

  def param_ticket_type
    params[:ticket_type]
  end

  def ticket_type
    return param_ticket_type if param_ticket_type.present?
    :sou
  end

  #
  # @see https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update#storelocation-to-the-rescue
  #
  # def storable_location?
  #   request.get? && is_navigational_format? && !request.xhr?
  # end

  # def store_user_location!
  #   store_location_for(resource_name, params[:redirect_to])
  # end

end
