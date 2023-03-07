module Operator::Tickets::Classifications::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      classification_new_breadcrumb
    ]
  end

  def show_edit_update_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      classification_edit_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def classification_new_breadcrumb
    [t("operator.tickets.classifications.new.title.#{ticket.ticket_type}"), '']
  end

  def classification_edit_breadcrumb
    [t("operator.tickets.classifications.edit.title.#{ticket.ticket_type}"), '']
  end

end
