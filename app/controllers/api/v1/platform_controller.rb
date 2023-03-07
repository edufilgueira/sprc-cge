class Api::V1::PlatformController < Api::V1::ApplicationController
  include CanCan::ControllerAdditions

  before_action :authenticate_api_user

  def authenticate_api_user
    unauthorized_response unless current_user.present? && current_user.user?
  end


  private

  def current_ability
    @current_ability ||= Abilities::User.factory(current_user)
  end

end
