class AdminController < ApplicationController
  include ::AuthorizedController

  before_action :require_admin

  helper_method [
    :namespace
  ]

  def require_admin
    redirect_to new_user_session_path unless current_user.admin?
  end

  # Helper methods

  def namespace
    :admin
  end

end
