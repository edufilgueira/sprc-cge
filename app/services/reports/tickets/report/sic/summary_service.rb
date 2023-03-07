class Reports::Tickets::Report::Sic::SummaryService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::SummaryPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_row(sheet, [ presenter.relevant_to_executive_count_str ])
    xls_add_row(sheet, [ presenter.call_center_sic_count_str ])
    xls_add_row(sheet, [ presenter.call_center_forwarded_count_str ])
    xls_add_row(sheet, [ presenter.sic_without_attendance_count_str ])
    xls_add_row(sheet, [ presenter.call_center_finalized_count_str ])
    xls_add_row(sheet, [ presenter.finalized_without_call_center_count_str ])
    xls_add_row(sheet, [ presenter.reopened_count_str ])
    xls_add_row(sheet, [ presenter.average_time_answer_str ])
  end

  def sheet_type
    :summary
  end

  def header_title
    I18n.t("services.reports.tickets.sic.summary.title", begin: beginning_date.to_s, end: end_date.to_s)
  end
end
