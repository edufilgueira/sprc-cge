class Transparency::MobileAppsController < TransparencyController
  include Transparency::MobileApps::Breadcrumbs
  include ::MobileApps::BaseController

  def mobile_apps
    filtered_mobile_apps.official
  end
end
