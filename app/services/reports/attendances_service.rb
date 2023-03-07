class Reports::AttendancesService < Reports::BaseService

  SHEETS = [
    Reports::Attendances::SummaryService,
    Reports::Attendances::SouService,
    Reports::Attendances::SicService,
    Reports::Attendances::ServiceTypeService,
    Reports::Attendances::ServiceTypeByUserService
  ]

  attr_reader :report

  def self.call(attendance_report_id)
    new(attendance_report_id).call
  end

  def initialize(attendance_report_id)
    @report = AttendanceReport.find(attendance_report_id)
    @beginning_date = report.starts_at.to_date
    @end_date = report.ends_at.to_date

    create_dir
  end

  def call
    set_total(self.class::SHEETS.count)
    set_progress(0)
    set_status(:generating)

    super
  end

  private

  def spreadsheet_dir_path
    Rails.root.join('public', 'files', 'downloads', 'attendance_reports', report.id.to_s)
  end

  def filename
    "attendance_report_#{report.id}.xlsx"
  end

  def generate_spreadsheet
    self.class::SHEETS.each_with_index do |sheet, index|
      sheet.call(xls_workbook, beginning_date, end_date)
      set_progress(index+1)
    end
  end

  def set_progress(processed)
    report.update_attribute(:processed, processed)
  end

  def set_status(status)
    report.update_attribute(:status, status)
  end

  def set_total(total)
    report.update_attribute(:total_to_process, total)
  end

  def finish_spreadsheet
    status = super ? :success : :error
    set_status(status)
  end
end
