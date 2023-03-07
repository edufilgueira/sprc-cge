class Reports::Tickets::Report::Sou::UsedInputService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::UsedInputPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    total_count = 0
    used_input_keys.each do |used_input|
      used_input_count = presenter.used_input_count(used_input)
      xls_add_row(sheet, [ presenter.used_input_str(used_input), used_input_count, presenter.used_input_percentage(used_input) ])
      total_count += used_input_count
    end

    xls_add_row(sheet, [ I18n.t("services.reports.tickets.sou.used_input.total"), total_count ])
  end

  def sheet_type
    :used_input
  end

  def used_input_keys
    Ticket.used_inputs.keys
  end
end
