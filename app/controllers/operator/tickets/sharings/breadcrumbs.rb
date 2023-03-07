module Operator::Tickets::Sharings::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      sharing_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def sharing_new_breadcrumb
    sharing_type = ticket.child? ? 'share' : 'add'

    [t("operator.tickets.sharings.new.#{ticket.ticket_type}.breadcrumb.title.#{sharing_type}"), '']
  end

end

