class TicketArea::SessionsController < Devise::SessionsController
  include TicketArea::SessionsBreadcrumbs
  include ::SingleAuthenticationGuard

  private

  def after_sign_in_path_for(resource)
    flash[:notice] = I18n.t("devise.sessions.ticket.signed_in.#{resource.ticket_type}")

    request.env['omniauth.origin'] || stored_location_for(resource) || ticket_area_ticket_path(resource)
  end

  def after_sign_out_path_for(_resource)
    flash[:notice] = I18n.t("devise.sessions.ticket.signed_out")

    new_ticket_session_path
  end
end
