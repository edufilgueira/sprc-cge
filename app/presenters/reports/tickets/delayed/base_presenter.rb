class Reports::Tickets::Delayed::BasePresenter

  attr_reader :scope

  COLUMNS = []

  def initialize(scope)
    @scope = scope
  end

  def rows
    scope.map { |ticket| row(ticket) }
  end

  private


  def row(ticket)
    self.class::COLUMNS.map { |column| send(column, ticket) }
  end

  def protocol(ticket)
    ticket.parent_protocol
  end

  def organ(ticket)
    return ticket.subnet_full_acronym if ticket.subnet?
    ticket.organ_acronym
  end

  def created_at(ticket)
    I18n.l(ticket.created_at, format: :date) if ticket.created_at.present?
  end

  def departments(ticket)
    ticket.ticket_departments.map(&:department_acronym).join("; ") if ticket.ticket_departments.present?
  end

  def delayed_days(ticket)
    ticket.deadline
  end

  def sou_type(ticket)
    ticket.sou_type_str
  end
end
