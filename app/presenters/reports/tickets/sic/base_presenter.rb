class Reports::Tickets::Sic::BasePresenter < Reports::Tickets::BasePresenter

  protected

  # CSAI
  # - com órgão
  # - com pai sem atendimento
  # - com pai com atendimento que seja :sic_forward
  def csai_only(scope)
    scope.where(<<-SQL, Attendance.service_types[:sic_forward], Attendance.service_types[:sou_forward])
      attendances.id IS NULL OR attendances.service_type IN (?, ?)
    SQL
  end

  def attendance_sic_completed(scope)
    scope.where(attendances: { service_type: :sic_completed })
  end

  def within_deadline(scope)
    scope.where('tickets.deadline >= 0')
  end

  def tickets_count(tickets)
    tickets.child_tickets.left_joins(parent: :attendance).count +
    tickets.parent_tickets.left_joins(:attendance).count
  end

  def tickets_attendance_scope(tickets)
    tickets.child_tickets.left_joins(parent: :attendance) +
    tickets.parent_tickets.left_joins(:attendance)
  end
end
