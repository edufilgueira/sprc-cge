module Tickets::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      [t('home.index.breadcrumb_title'), root_path],
      [t("sessions.new.ticket_types.#{ticket_type}.title"), new_user_session_path(ticket_type: ticket_type)],
      [t(".#{ticket.ticket_type}.#{ticket.access_type}.title"), '']
    ]
  end
end
