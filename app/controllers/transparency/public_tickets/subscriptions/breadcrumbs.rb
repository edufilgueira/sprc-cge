module Transparency::PublicTickets::Subscriptions::Breadcrumbs

  protected

  def new_create_breadcrumbs
    build_breadcrumbs
  end

  def show_edit_update_breadcrumbs
    build_breadcrumbs
  end

  private

  def build_breadcrumbs
    [
      [t("transparency.public_tickets.index.#{ticket.ticket_type}.title"), transparency_public_tickets_path(ticket_type: ticket.ticket_type)],
      [t("transparency.public_tickets.subscriptions.breadcrumbs.ticket.#{ticket.ticket_type}", protocol: ticket.protocol), transparency_public_ticket_path(ticket)],
      [t("transparency.public_tickets.subscriptions.new.title.#{ticket.ticket_type}"), '']
    ]
  end
end
