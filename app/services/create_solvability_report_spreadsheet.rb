##
# Cria relatório de matérias
#
##
class CreateSolvabilityReportSpreadsheet < BaseTicketSpreadsheetService
  include Reports::Tickets::Report::Sheets


  SIC_SHEETS = [
    Reports::Tickets::Solvability::SicService
  ]

  SOU_SHEETS = [
    Reports::Tickets::Solvability::SouService
  ]

  BASE_DIR = ['public', 'files', 'downloads', 'solvability_report'].join('/').to_s

  # Attributes

  attr_reader :solvability_report, :report_data

  def initialize(solvability_report_id)
    super

    @solvability_report = SolvabilityReport.find_by_id(solvability_report_id)
  end


  def call
    return unless solvability_report.present?

    set_total(tickets.count)
    set_progress(0, total_steps)
    set_status(:preparing)

    create_dir

    generate
  end

  def self.call(solvability_report_id)
    new(solvability_report_id).call
  end

  private

  def total_steps
    sheets.count
  end

  def generate
    set_status(:generating)
    generate_spreadsheet
    finish_spreadsheet
  end

  def generate_spreadsheet
    sheets.each_with_index do |report_sheet, index|
      set_progress(index + 1)
      report_sheet.call(xls_workbook, solvability_report)
    end
  end

  def sheets
    solvability_report.ticket_type_filter == 'sou' ? SOU_SHEETS : SIC_SHEETS
  end


  # Resources

  def spreadsheet_object
    solvability_report
  end
end
