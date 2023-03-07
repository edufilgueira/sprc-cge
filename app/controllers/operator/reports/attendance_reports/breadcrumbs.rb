module Operator::Reports::AttendanceReports::Breadcrumbs
  include ::Reports::BaseBreadcrumbs

  private

  def report_type
    :attendance_reports
  end

  def report
    attendance_report
  end
end
