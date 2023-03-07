class OperatorController < ApplicationController
  include ::AuthorizedController

  before_action :require_operator

  helper_method [
    :namespace
  ]

  # Helper methods

  def namespace
    :operator
  end

  private

  def require_operator
    redirect_to new_user_session_path unless current_user.operator?
  end
end
