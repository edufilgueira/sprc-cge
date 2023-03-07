class Operator::Reports::AttendanceReportsController < OperatorController
  include ::PaginatedController
  include ::FilteredController
  include Operator::Reports::AttendanceReports::Breadcrumbs
  include ::Operator::BaseTicketSpreadsheetController

  PERMITTED_PARAMS = [
    :title,
    :starts_at,
    :ends_at
  ]

  helper_method [:attendance_reports, :attendance_report]

  # Actions

  def create
    super { generate_spreadsheet }
  end


  # Helper methods

  def attendance_reports
    paginated(filtered_resources)
  end

  def attendance_report
    resource
  end

  private

  def new_resource
    @new_resource = resources.new(resource_params)
    @new_resource.user = current_user
    @new_resource
  end

  def generate_spreadsheet
    if attendance_report.persisted? && attendance_report.valid?
      Reports::AttendancesService.delay.call(attendance_report.id)
    end
  end

end
