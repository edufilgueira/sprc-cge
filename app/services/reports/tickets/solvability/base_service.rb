class Reports::Tickets::Solvability::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :solvability_report

  def self.call(xls_workbook, solvability_report)
    new(xls_workbook, solvability_report).call
  end

  def initialize(xls_workbook, solvability_report)
    @xls_workbook = xls_workbook
    @solvability_report = solvability_report
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

    presenter.rows.each do |row|
      xls_add_row(sheet, row)
    end
  end

  def sheet_type
  end

  def default_scope
    solvability_report.filtered_scope.without_other_organs
      .without_internal_status(Ticket::INVALIDATED_STATUSES)
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

  def worksheet_title(_worksheet_type)
    I18n.t("services.reports.tickets.solvability.#{solvability_report.ticket_type_filter}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, [title])
    xls_add_header(sheet, headers)
  end

  def headers
    columns.map do |column|
      I18n.t("services.reports.tickets.solvability.headers.#{column}")
    end
  end

  def title
    I18n.t("services.reports.tickets.solvability.title", begin: I18n.l(beginning_date), end: I18n.l(end_date, format: :date))
  end

  def columns
    presenter.class::COLUMNS
  end

    def date_filter
    solvability_report.filters[:confirmed_at]
  end
end
