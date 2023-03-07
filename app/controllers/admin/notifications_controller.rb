class Admin::NotificationsController < AdminController
  include Admin::Notifications::Breadcrumbs
  include ::Notifications::BaseController
end
