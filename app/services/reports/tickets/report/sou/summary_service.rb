class Reports::Tickets::Report::Sou::SummaryService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::SummaryPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_row(sheet, [ presenter.relevant_to_executive_count_str ])
    xls_add_row(sheet, [ presenter.invalidated_count_str ])
    xls_add_row(sheet, [ presenter.other_organs_count_str ])
    xls_add_row(sheet, [ presenter.anonymous_count_str ])
    xls_add_row(sheet, [ presenter.total_count_str ])
    xls_add_row(sheet, [ presenter.reopened_count_str ])
    xls_add_row(sheet, [ presenter.average_time_answer_str ])
  end

  def sheet_type
    :summary
  end

  def header_title
    I18n.t("services.reports.tickets.sou.summary.title", begin: beginning_date.to_s, end: end_date.to_s)
  end

  def default_scope
    ticket_report.filtered_scope.without_characteristic
  end
end
