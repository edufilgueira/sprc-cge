class Reports::Tickets::Report::Sic::BudgetProgramService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::BudgetProgramPresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
  end

  def sheet_type
    :budget_program
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    columns.map do |column|
      I18n.t("services.reports.tickets.sic.budget_program.headers.#{column}")
    end
  end
end
