class Reports::Tickets::Report::Sic::NeighborhoodService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::NeighborhoodPresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
    xls_add_row(sheet, [I18n.t("services.reports.tickets.sic.neighborhood.total"), presenter.total_count])
  end

  def sheet_type
    :neighborhood
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.sic.neighborhood.headers.#{column}")
    end
  end
end
