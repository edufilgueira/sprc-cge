class Transparency::SocietyMobileAppsController < TransparencyController
  include Transparency::MobileApps::Breadcrumbs
  include ::MobileApps::BaseController

  def mobile_apps
    filtered_mobile_apps.unofficial
  end
end
