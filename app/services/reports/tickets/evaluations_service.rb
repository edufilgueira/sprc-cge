class Reports::Tickets::EvaluationsService < BaseTicketSpreadsheetService

  SOU_SHEET = Reports::Tickets::Evaluations::SouService
  SIC_SHEET = Reports::Tickets::Evaluations::SicService

  BASE_DIR = ['public', 'files', 'downloads', 'evaluation_exports'].join('/').to_s

  # Attributes

  attr_reader :evaluation_export

  def initialize(evaluation_export_id)
    super

    @evaluation_export = EvaluationExport.find_by(id: evaluation_export_id)
  end

  def call
    set_total(tickets.count)
    set_progress(0, total_steps)
    set_status(:preparing)

    create_dir
    generate_spreadsheet
    finish_spreadsheet
  end

  def self.call(evaluation_export_id)
    new(evaluation_export_id).call
  end

  private

  def sheets
    type_sheet = sou? ? SOU_SHEET : SIC_SHEET

    [ Reports::Tickets::Evaluations::SummaryService, type_sheet ]
  end

  def total_steps
    sheets.count
  end

  def generate_spreadsheet
    set_status(:generating)
    sheets.each_with_index do |export_sheet, index|
      set_progress(index + 1)
      export_sheet.call(xls_workbook, evaluation_export.id)
    end
  end

  def ticket_type
    evaluation_export.ticket_type_filter
  end

  def sic?
    ticket_type.to_s == 'sic'
  end

  def sou?
    ticket_type.to_s == 'sou'
  end

    # Resources

  def spreadsheet_object
    evaluation_export
  end
end
