class Operator::Reports::TicketReportsController < OperatorController
  include ::PaginatedController
  include Operator::BaseTicketSpreadsheetController
  include Operator::Reports::TicketReports::Breadcrumbs


  PERMITTED_PARAMS = [
    :title,
    filters: [
      :ticket_type,
      :expired,
      :organ,
      :subnet,
      :budget_program,
      :topic,
      :subtopic,
      :other_organs,
      :rede_ouvir_scope,
      :deadline,
      :priority,
      :internal_status,
      :search,
      :denunciation,
      :sou_type,
      :state,
      :city,
      :used_input,
      :answer_type,
      :data_scope,
      :department,
      confirmed_at: [
        :start,
        :end
      ],
      sheets: []
    ]
  ]

  helper_method [:ticket_reports, :ticket_report]

  # Actions

  def create
    ticket_report.status = :preparing
    ticket_report.user = current_user
    ensure_confirmed_at_presence

    super

    generate_spreadsheet
  end

  # Helper methods

  def ticket_reports
    @ticket_reports ||= paginated_ticket_reports
  end

  def ticket_report
    resource
  end

  private

  def ensure_confirmed_at_presence
    ticket_report.filters[:confirmed_at] = {} unless ticket_report.filters[:confirmed_at].present?

    unless ticket_report.filters[:confirmed_at][:start].present?
      ticket_report.filters[:confirmed_at][:start] = Ticket.first_confirmed_date
    end

    unless ticket_report.filters[:confirmed_at][:end].present?
      ticket_report.filters[:confirmed_at][:end] = Date.today
    end
  end

  def paginated_ticket_reports
    paginated(sorted_ticket_reports)
  end

  def sorted_ticket_reports
    current_user.ticket_reports.sorted
  end

  def accessible_ticket_type?(ticket_type)
    Ticket.ticket_types.include?(ticket_type)
  end

  def generate_spreadsheet
    if ticket_report.persisted? && ticket_report.valid?
      CreateTicketReportSpreadsheet.call(ticket_report.id)
    end
  end
end
