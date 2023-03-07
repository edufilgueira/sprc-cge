class Reports::Tickets::Report::Sou::SouTypeService < Reports::Tickets::Report::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::SouTypePresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    sou_type_keys.each do |sou_type|
      sou_type_count = presenter.sou_type_count(sou_type)
      xls_add_row(sheet, [ presenter.sou_type_str(sou_type), sou_type_count, presenter.sou_type_percentage(sou_type)])
    end

    xls_add_row(sheet, [ I18n.t("services.reports.tickets.sou.sou_type.total"), presenter.total_count ])
  end

  def sheet_type
    :sou_type
  end

  def sou_type_keys
    Ticket.sou_types.keys
  end
end
