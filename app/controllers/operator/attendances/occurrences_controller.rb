class Operator::Attendances::OccurrencesController < OperatorController

  PERMITTED_PARAMS = [:description]

  helper_method [:occurrence, :attendance, :new_occurrence, :ticket]

  def create
    occurrence.attendance = attendance
    occurrence.created_by = current_user

    if occurrence.save && attendance.ticket.present?
      register_ticket_log
    end

    render partial: 'operator/attendances/occurrences'
  end

  def occurrence
    resource
  end

  def attendance
    Attendance.find(params[:attendance_id])
  end

  def ticket
    attendance.ticket
  end

  def new_occurrence
    occurrence.persisted? ? Occurrence.new : occurrence
  end

  private

  def register_ticket_log
    RegisterTicketLog.call(attendance.ticket, current_user, :occurrence, { resource: occurrence, data: data_attributes })
  end

  def data_attributes
    {
      responsible_as_author: current_user.as_author
    }
  end
end
