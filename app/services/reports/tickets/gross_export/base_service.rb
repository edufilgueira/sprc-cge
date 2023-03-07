class Reports::Tickets::GrossExport::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :gross_export

  def self.call(xls_workbook, gross_export)
    new(xls_workbook, gross_export).call
  end

  def initialize(xls_workbook, gross_export)
    @xls_workbook = xls_workbook
    @gross_export = gross_export
  end

  def call
    generate_spreadsheet
  end

  def beginning_date
    return Date.new(0) unless date_filter.present?
    date_filter[:start].to_date
  end

  def end_date
    return Date.today.end_of_day unless date_filter.present?
    date_filter[:end].to_date.end_of_day
  end

  private

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
  end

  #
  # Implementar na classe que estender
  #
  def sheet_type
  end

  def default_scope
    gross_export.filtered_scope
  end

  def generate_spreadsheet
    worksheet_title = sanitized_worksheet_title(sheet_type)

    xls_workbook.add_worksheet(name: worksheet_title) do |sheet|
      xls_add_empty_rows(sheet, 2)
      build_sheet(sheet)
    end
  end

  def date_range
    beginning_date..end_date
  end

  def worksheet_title(worksheet_type)
    I18n.t("services.reports.tickets.gross_export.#{worksheet_type}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.active_columns.map do |column|
      I18n.t("services.reports.tickets.gross_export.#{sheet_type}.headers.#{column}")
    end
  end

  def header_title
    I18n.t("services.reports.tickets.gross_export.#{sheet_type}.title")
  end

  def date_filter
    gross_export.filters[:confirmed_at]
  end
end
