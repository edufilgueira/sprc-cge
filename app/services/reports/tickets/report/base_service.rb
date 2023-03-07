class Reports::Tickets::Report::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :ticket_report

  def self.call(xls_workbook, ticket_report)
    new(xls_workbook, ticket_report).call
  end

  def initialize(xls_workbook, ticket_report)
    @xls_workbook = xls_workbook
    @ticket_report = ticket_report
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

  #
  # Implementar na classe que estender
  #
  def build_sheet(sheet)
  end

  #
  # Implementar na classe que estender
  #
  def sheet_type
  end

  def default_scope
    ticket_report.filtered_scope.without_other_organs
      .without_internal_status(Ticket::INVALIDATED_STATUSES)   
      .without_characteristic
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
    I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{worksheet_type}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, [ header_title ])
  end

  def header_title
    I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.title")
  end

  def columns
    presenter.class::COLUMNS - organ_column
  end

  def organ_column
    include_organ? ? [] : [:organ]
  end

  def include_organ?
    user.cge? || user.call_center_operator?
  end

  def user
    ticket_report.user
  end

  def date_filter
    ticket_report.filters[:confirmed_at]
  end
end
