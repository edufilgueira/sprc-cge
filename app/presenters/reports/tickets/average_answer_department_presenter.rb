class Reports::Tickets::AverageAnswerDepartmentPresenter
  attr_reader :scope

  COLUMNS = [
    :organ,
    :department,
    :average,
    :total
  ]

  def initialize(scope)
    @scope = scope
  end

  def average_time(department)
    total_days = 0
    ticket_departments_in_scope(department).each do |ticket_department|
      date_answer = ticket_department_answered_at(ticket_department)
      ticket_department_days = (date_answer.to_date - ticket_department.created_at.to_date).to_i
      total_days += ticket_department_days
    end

    total = amount_count(department)

    return '' if total <= 0

    total_days / total
  end

  def amount_count(department)
    ticket_departments_in_scope(department).count
  end

  private

  def ticket_departments_in_scope(department)
    TicketDepartment.where(answer: :answered, department_id: department.id, ticket_id: scope.ids)
  end

  def ticket_department_answered_at(ticket_department)
    ticket_log = ticket_department.ticket.ticket_logs.answer.where("ticket_logs.data LIKE ?", "%responsible_department_id: #{ticket_department.department.id}%").last
    ticket_log&.created_at || ticket_department.updated_at
  end
end
