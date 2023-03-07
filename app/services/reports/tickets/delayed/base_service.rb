class Reports::Tickets::Delayed::BaseService < BaseSpreadsheetService

  attr_reader :xls_workbook, :beginning_date, :end_date

  def self.call(xls_workbook, beginning_date, end_date)
    new(xls_workbook, beginning_date, end_date).call
  end

  def initialize(xls_workbook, beginning_date, end_date)
    @xls_workbook = xls_workbook
    @beginning_date = beginning_date
    @end_date = end_date
  end

  def call
    generate_spreadsheet
  end

  private

  #
  # Implementar na classe que estender
  #
  def sheet_type
  end

  def default_scope
    Ticket.active.left_joins(:tickets)
      .where(confirmed_at: date_range, tickets_tickets: { id: nil })
      .where('tickets.deadline < 0 OR tickets_tickets.deadline < 0')
  end

  def generate_spreadsheet
    title = sanitized_worksheet_title(sheet_type)

    xls_workbook.add_worksheet(name: title) do |sheet|
      build_sheet(sheet)
    end
  end

  def date_range
    beginning_date..end_date
  end

  def worksheet_title(worksheet_type)
    I18n.t("services.reports.tickets.delayed.#{worksheet_type}.sheet_name")
  end

  def add_header(sheet)
    xls_add_header(sheet, [ title ])
    xls_add_header(sheet, headers)
  end

  def title
    I18n.t("services.reports.tickets.delayed.#{sheet_type}.title", begin: beginning_date.to_s, end: end_date.to_s)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.delayed.#{sheet_type}.headers.#{column}")
    end
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
  end
end
