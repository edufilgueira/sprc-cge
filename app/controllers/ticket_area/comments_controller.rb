class TicketArea::CommentsController < TicketAreaController
  include ::Tickets::Comments::BaseController

  def ticket
    current_ticket
  end

  def comment_form_url
    [:ticket_area, new_comment]
  end

end
