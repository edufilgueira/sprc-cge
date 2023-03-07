class Operator::NotificationsController < OperatorController
  include Operator::Notifications::Breadcrumbs
  include ::Notifications::BaseController
end
