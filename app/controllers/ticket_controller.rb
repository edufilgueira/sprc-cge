class TicketAreaController < ApplicationController
  before_action :authenticate_ticket!

  private

  def current_ability
    @current_ability ||= Abilities::Ticket.new(current_ticket)
  end
end
