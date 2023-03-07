##
# Cria relatório de matérias
#
##
class CreateGrossExportSpreadsheet < BaseTicketSpreadsheetService

  SOU_SHEET = Reports::Tickets::GrossExport::SouService
  SIC_SHEET = Reports::Tickets::GrossExport::SicService

  BASE_DIR = ['public', 'files', 'downloads', 'gross_export'].join('/').to_s

  # Attributes

  attr_reader :gross_export

  def initialize(gross_export_id)
    super

    @gross_export = GrossExport.find_by_id(gross_export_id)
  end


  def call
    return unless gross_export.present?

    set_total(tickets.count)
    set_progress(0, total_steps)
    set_status(:preparing)

    create_dir

    generate
  end

  def self.call(gross_export_id)
    new(gross_export_id).call
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
    sheets.each_with_index do |export_sheet, index|
      # generate_spreadsheet_by_group, generate_spreadsheet_by_theme...
      set_progress(index + 1)
      export_sheet.call(xls_workbook, gross_export)
    end
  end

  def sheets
    type_sheet = gross_export.ticket_type_filter == 'sou' ? SOU_SHEET : SIC_SHEET

    [ Reports::Tickets::GrossExport::SummaryService, type_sheet ]
  end


  # Resources

  def spreadsheet_object
    gross_export
  end
end
