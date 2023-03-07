class Admin::MobileAppsController < AdminController
  include Admin::MobileApps::Breadcrumbs
  include ::MobileApps::BaseController

  PERMITTED_PARAMS = [
    :name,
    :description,
    :icon,
    :official,
    :link_apple_store,
    :link_google_play,
    mobile_tag_ids: []
  ]

  helper_method [:mobile_app]

  # Helper methods

  def mobile_app
    resource
  end
end
