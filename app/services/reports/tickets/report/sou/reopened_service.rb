class Reports::Tickets::Report::Sou::ReopenedService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::ReopenedPresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)

    presenter.rows(date_range).each { |row| xls_add_row(sheet, row) }
  end

  def sheet_type
    :reopened
  end

  def add_header(sheet)
    xls_add_header(sheet, headers)
  end

  def headers
    presenter.class::COLUMNS.map do |column|
      I18n.t("services.reports.tickets.sou.reopened.headers.#{column}")
    end
  end
end
