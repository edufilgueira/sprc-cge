class Operator::Tickets::AttendanceResponsesController < OperatorController
  include Operator::Tickets::AttendanceResponses::Breadcrumbs

  PERMITTED_PARAMS = [
    :description
  ]

  helper_method [:ticket, :attendance_response]

  # Callbacks

  before_action :can_create_attendance_response_ticket

  # Actions

  def failure
    attendance_response.response_type = :failure

    save_attendance_response
  end

  def success
    attendance_response.response_type = :success
    ticket.update_attributes(call_center_feedback_at: DateTime.now, call_center_status: :with_feedback)

    save_attendance_response
  end

  # Helpers

  def attendance_response
    resource
  end

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end

  # Private

  private

  def new_resource
    ticket.attendance_responses.build(resource_params) if ticket.present?
  end

  def find_resource
    ticket.present? && ticket.attendance_responses.find(params[:id])
  end

  def redirect_to_ticket
    redirect_to operator_call_center_ticket_path(ticket), notice: t('.done')
  end

  def can_create_attendance_response_ticket
    authorize! :create, AttendanceResponse
  end

  def save_attendance_response
    if attendance_response.save
      register_ticket_log
      redirect_to_ticket
    else
      flash.now[:alert] = t('.error')
      render :new
    end
  end

  def register_ticket_log
    RegisterTicketLog.call(ticket, current_user, :attendance_response, { resource: attendance_response })
  end
end
