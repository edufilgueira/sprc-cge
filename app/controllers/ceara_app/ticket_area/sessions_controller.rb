class CearaApp::TicketArea::SessionsController < TicketArea::SessionsController
  
  layout 'ceara_app'

  def after_sign_in_path_for(resource)
    flash[:notice] = I18n.t("devise.sessions.ticket.signed_in.#{resource.ticket_type}")

    ceara_app_ticket_area_ticket_path(resource)
  end

  def after_sign_out_path_for(_resource)
    flash[:notice] = I18n.t("devise.sessions.ticket.signed_out")

    new_ceara_app_ticket_session_path
  end
end
