class Reports::Tickets::Evaluations::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :evaluation_export

  def self.call(xls_workbook, evaluation_export_id)
    new(xls_workbook, evaluation_export_id).call
  end

  def initialize(xls_workbook, evaluation_export_id)
    @xls_workbook = xls_workbook
    @evaluation_export = EvaluationExport.find_by(id: evaluation_export_id)
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

  def average_arr(arr)
    return 0 if arr.size == 0
    (arr.sum.to_f / arr.size).round(2)
  end

  def citizen_expectation(arr)
    return 0 if arr.size == 0
    (arr[1].to_f - arr[0].to_f) / arr[0]
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
    evaluation_export.filtered_scope
  end

  def generate_spreadsheet
    worksheet_title = sanitized_worksheet_title(sheet_type)

    xls_workbook.add_worksheet(name: worksheet_title) do |sheet|
      xls_add_empty_rows(sheet, 2)
      build_sheet(sheet)
    end
  end

  def date_range
    beginning_date..end_date.end_of_day
  end

  def worksheet_title(worksheet_type)
    I18n.t("services.reports.tickets.evaluations.#{worksheet_type}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def header_title
    I18n.t("services.reports.tickets.evaluations.#{sheet_type}.title")
  end

  def ticket_type
    evaluation_export.ticket_type_filter
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.evaluations.headers.#{column}")
    end
  end

   def date_filter
    evaluation_export.filters[:confirmed_at]
  end
end
