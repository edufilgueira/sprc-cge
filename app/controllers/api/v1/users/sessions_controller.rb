class Api::V1::Users::SessionsController < Devise::SessionsController
  include Api::BaseController

  skip_before_action :verify_authenticity_token

  # Actions

  def create
    return unauthorized_response if user.blank?
    object_response(authentication_token: token)
  end

  def destroy
    return head :no_content unless current_user.blank? || Tiddle.expire_token(current_user, request).blank?
    unauthorized_response
  end


  # Privates

  private

  ## Methods

  def user
    @user ||= warden.authenticate(auth_options)
  end

  def token
    @token ||= Tiddle.create_and_return_token(user, request)
  end

  def verify_signed_out_user
    # this is invoked before destroy and we have to override it
  end

end
