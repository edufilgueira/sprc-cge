class Api::V1::OperatorController < Api::V1::ApplicationController
  include CanCan::ControllerAdditions

  before_action :authenticate_api_sectoral

  def authenticate_api_sectoral
    # assumindo que apenas operadores setoriais tem acesso a esta api
    unauthorized_response unless current_user.present? && current_user.operator?
  end

  private

  def current_ability
    @current_ability ||= Abilities::User.factory(current_user)
  end
end
