module Operator::Tickets::Appeals::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t("operator.tickets.appeals.new.title"), '']
    ]
  end

  def index_breadcrumbs
  end
end
