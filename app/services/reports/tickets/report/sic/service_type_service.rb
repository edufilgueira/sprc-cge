class Reports::Tickets::Report::Sic::ServiceTypeService <  Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::ServiceTypePresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows.each { |row| xls_add_row(sheet, row) }
  end

  def sheet_type
    :service_type
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    columns.map do |column|
      I18n.t("services.reports.tickets.sic.service_type.headers.#{column}")
    end
  end
end

