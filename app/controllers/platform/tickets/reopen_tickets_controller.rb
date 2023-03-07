class Platform::Tickets::ReopenTicketsController < PlatformController
  include ::Tickets::Reopens::BaseController
  include Platform::Tickets::ReopenTickets::Breadcrumbs

  private

  def namespace
    :platform
  end
end
