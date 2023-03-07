module Operator::Reports::TicketReports::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :ticket_reports
  end

  def report
    ticket_report
  end
end
