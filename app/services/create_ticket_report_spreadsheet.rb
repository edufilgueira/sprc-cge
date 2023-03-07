##
# Cria relatório de matérias
#
##
class CreateTicketReportSpreadsheet < BaseTicketSpreadsheetService
  include Reports::Tickets::Report::Sheets


  BASE_DIR = ['public', 'files', 'downloads', 'ticket_report'].join('/').to_s

  # Attributes

  attr_reader :ticket_report, :report_data

  def initialize(ticket_report_id)
    super

    @ticket_report = TicketReport.find_by_id(ticket_report_id)
  end


  def call
    return unless ticket_report.present?

    set_total(tickets.count)
    set_progress(0, total_steps)
    set_status(:preparing)

    create_dir

    generate
  end

  def self.call(ticket_report_id)
    new(ticket_report_id).call
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
      # generate_spreadsheet_by_group, generate_spreadsheet_by_theme...
      set_progress(index + 1)
      report_sheet.call(xls_workbook, ticket_report)
    end
  end

  def sheets
    if ticket_report.filters[:sheets].present?
      ticket_report.filters[:sheets].map(&:constantize)
    else
      ticket_report.ticket_type_filter == 'sou' ? SOU_SHEETS : SIC_SHEETS
    end
  end

  # Resources

  def spreadsheet_object
    ticket_report
  end
end
