module Operator::Tickets::ChangeTypes::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      change_type_new_breadcrumb
    ]
  end

  def index_breadcrumbs
  end

  private

  def change_type_new_breadcrumb
    [t('shared.tickets.change_types.new.title'), '']
  end

  def tickets_index_breadcrumb
    [t("operator.tickets.index.#{ticket_original_type}.breadcrumb_title"), url_for([:operator, :tickets, ticket_type: ticket_original_type, only_path: true])]
  end

  def ticket_show_breadcrumb
    [ticket.title, url_for([:operator, ticket, ticket_type: ticket_original_type, only_path: true])]
  end
end
