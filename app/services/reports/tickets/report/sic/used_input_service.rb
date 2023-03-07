class Reports::Tickets::Report::Sic::UsedInputService < Reports::Tickets::Report::Sic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::UsedInputPresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    total_count = 0
    used_input_keys.each do |used_input|
      used_input_count = presenter.used_input_count(used_input)
      xls_add_row(sheet, [ presenter.used_input_str(used_input), used_input_count, presenter.used_input_percentage(used_input) ])
      total_count += used_input_count
    end

    xls_add_row(sheet, [ I18n.t("services.reports.tickets.sic.used_input.total"), total_count ])
  end

  def sheet_type
    :used_input
  end

  def used_input_keys
    Ticket.used_inputs.keys
  end
end
