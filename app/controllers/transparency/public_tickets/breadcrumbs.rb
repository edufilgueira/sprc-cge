module Transparency::PublicTickets::Breadcrumbs


  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t(".#{ticket_type}.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("transparency.public_tickets.index.#{ticket_type}.title"), transparency_public_tickets_path(ticket_type: ticket.ticket_type)],
      [ ticket.title, '']
    ]
  end

end

