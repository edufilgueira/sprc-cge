class TicketArea::NotificationsController < TicketAreaController
  include ::TicketArea::Notifications::Breadcrumbs
  include ::Notifications::BaseController
end
