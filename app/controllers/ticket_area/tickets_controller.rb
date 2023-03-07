class TicketArea::TicketsController < TicketAreaController
  include ::Tickets::BaseController

  load_resource except: :create
  authorize_resource

  helper_method [:justification]

  # Action

  def show
    if ticket.create_password?
      ticket.create_password
      bypass_sign_in(resource)
      notify
    end

    if print?
      render template: 'shared/tickets/print', layout: 'print'
    end
  end

  # Private

  private

  def justification
  end
end
