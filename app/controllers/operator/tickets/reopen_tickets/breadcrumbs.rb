module Operator::Tickets::ReopenTickets::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t("operator.tickets.reopen_tickets.new.#{ticket.ticket_type}.title"), '']
    ]
  end

  def index_breadcrumbs
  end
end
