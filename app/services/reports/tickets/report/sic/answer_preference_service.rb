class Reports::Tickets::Report::Sic::AnswerPreferenceService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::AnswerPreferencePresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    total_count = 0
    answer_type_keys.each do |answer_type|
      answer_type_count = presenter.answer_type_count(answer_type)
      xls_add_row(sheet, [ presenter.answer_type_str(answer_type), answer_type_count, presenter.answer_type_percentage(answer_type) ])
      total_count += answer_type_count
    end

    xls_add_row(sheet, [ I18n.t("services.reports.tickets.sic.answer_type.total"), total_count ])
  end

  def sheet_type
    :answer_type
  end

  def answer_type_keys
    Ticket.answer_types.keys
  end
end
