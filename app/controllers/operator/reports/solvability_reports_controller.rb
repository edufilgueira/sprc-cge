class Operator::Reports::SolvabilityReportsController < OperatorController
  include ::PaginatedController

  include Operator::BaseTicketSpreadsheetController
  include Operator::Reports::SolvabilityReports::Breadcrumbs

  PERMITTED_PARAMS = [
    :title,
    filters: [
      :ticket_type,
      confirmed_at: [
        :start,
        :end
      ]
    ]
  ]

  helper_method [:solvability_reports, :solvability_report]

  # Actions

  def create
    solvability_report.status = :preparing
    solvability_report.user = current_user
    ensure_confirmed_at_presence

    super

    generate_spreadsheet
  end

  # Helper methods

  def solvability_reports
    @solvability_reports ||= paginated_solvability_reports
  end

  def solvability_report
    resource
  end

  private

  def ensure_confirmed_at_presence
    solvability_report.filters[:confirmed_at] = {} unless solvability_report.filters[:confirmed_at].present?

    unless solvability_report.filters[:confirmed_at][:start].present?
      solvability_report.filters[:confirmed_at][:start] = Ticket.first_confirmed_date
    end

    unless solvability_report.filters[:confirmed_at][:end].present?
      solvability_report.filters[:confirmed_at][:end] = Date.today
    end
  end

  def paginated_solvability_reports
    paginated(sorted_solvability_reports)
  end

  def sorted_solvability_reports
    current_user.solvability_reports.sorted
  end

  def accessible_ticket_type?(ticket_type)
    Ticket.ticket_types.include?(ticket_type)
  end

  def generate_spreadsheet
    if solvability_report.persisted? && solvability_report.valid?
      CreateSolvabilityReportSpreadsheet.delay(queue: 'exports').call(solvability_report.id)
    end
  end
end
