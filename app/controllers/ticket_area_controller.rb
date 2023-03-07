class TicketAreaController < ApplicationController
  before_action :authenticate_ticket!
  before_action :require_ticket

  helper_method [
    :namespace
  ]

  # Helper methods

  def namespace
    :ticket_area
  end

  private

  def current_ability
    @current_ability ||= Abilities::Ticket.new(current_ticket)
  end

  def require_ticket
    redirect_to new_ticket_session_path unless current_ticket.present?
  end
end
