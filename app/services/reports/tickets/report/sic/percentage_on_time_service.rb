class Reports::Tickets::Report::Sic::PercentageOnTimeService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::PercentageOnTimePresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_row(sheet, [])

    xls_add_row(sheet, [presenter.total_count_str, presenter.total_count])
    xls_add_row(sheet, [presenter.total_completed_count_str, presenter.total_completed_count])

    xls_add_row(sheet, [ presenter.all_on_time_str, presenter.all_on_time ])
    xls_add_row(sheet, [ presenter.call_center_on_time_str, presenter.call_center_on_time ])
    xls_add_row(sheet, [ presenter.csai_on_time_str, presenter.csai_on_time ])
  end

  def sheet_type
    :percentage_on_time
  end

  def header_title
    I18n.t("services.reports.tickets.sic.percentage_on_time.title")
  end
end
