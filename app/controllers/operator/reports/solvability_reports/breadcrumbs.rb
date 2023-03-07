module Operator::Reports::SolvabilityReports::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :solvability_reports
  end

  def report
    solvability_report
  end
end
