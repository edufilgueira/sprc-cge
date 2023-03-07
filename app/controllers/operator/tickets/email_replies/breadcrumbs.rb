module Operator::Tickets::EmailReplies::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  protected

  def ticket_type
    ticket.ticket_type
  end

  def show_edit_update_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      [t('operator.tickets.email_replies.edit.title'), '']
    ]
  end
end
