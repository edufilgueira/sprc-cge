module Operator::Tickets::TransferOrgans::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t("operator.tickets.transfer_organs.new.title.#{ticket.ticket_type}"), '']
    ]
  end

  def show_edit_update_breadcrumbs
  end

  def index_breadcrumbs
  end

end
