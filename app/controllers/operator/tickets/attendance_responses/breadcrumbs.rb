module Operator::Tickets::AttendanceResponses::Breadcrumbs
  include Operator::Tickets::Breadcrumbs

  def actions_breadcrumbs
    {
      'new': new_create_breadcrumbs,
      'failure': new_create_breadcrumbs,
      'success': new_create_breadcrumbs
    }
  end

  protected

  def new_create_breadcrumbs
    [
      tickets_index_breadcrumb,
      ticket_show_breadcrumb,
      attendance_response_new_breadcrumb
    ]
  end

  def show_edit_update_breadcrumbs
  end

  def index_breadcrumbs
  end

  private

  def attendance_response_new_breadcrumb
    [t("operator.tickets.attendance_responses.new.title", ticket_title: ticket.title), '']
  end

end
