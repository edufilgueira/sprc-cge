class Platform::NotificationsController < PlatformController
  include Platform::Notifications::Breadcrumbs
  include ::Notifications::BaseController
end
