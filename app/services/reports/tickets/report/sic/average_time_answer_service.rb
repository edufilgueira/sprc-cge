class Reports::Tickets::Report::Sic::AverageTimeAnswerService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::AverageTimeAnswerPresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)

    headers_table = [
      I18n.t("presenters.reports.tickets.sic.average_time_answer.headers.type"),
      I18n.t("presenters.reports.tickets.sic.average_time_answer.headers.average"),
      I18n.t("presenters.reports.tickets.sic.average_time_answer.headers.total")
    ]

    xls_add_row(sheet, headers_table )

    rows = [
      :call_center_and_csai,
      :csai
    ]

    rows.each do |row|
      xls_add_row(sheet, [
        presenter.average_type_str(row),
        presenter.average_time_str(row),
        presenter.amount_count(row)
      ])
    end
  end

  def sheet_type
    :average_time_answer
  end
end
