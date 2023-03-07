class Reports::Tickets::Report::Sic::OrganService < Reports::Tickets::Report::Sic::BaseService

  def call
    return if ticket_report.user.sectoral?
    super
  end

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::OrganPresenter.new(report_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.call_center_demand') ])

    total_demand = presenter.call_center_organ_demand_count.values.sum
    presenter.call_center_organ_demand_count.each do |organ, demand|
      xls_add_row(sheet, [ organ, demand, presenter.calc_percentage(demand, total_demand) ])
    end

    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.total'), total_demand ])

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.call_center_organ_forwarded') ])

    total_demand = presenter.call_center_organ_forwarded_count.values.sum
    presenter.call_center_organ_forwarded_count.each do |organ, demand|
      xls_add_row(sheet, [ organ, demand, presenter.calc_percentage(demand, total_demand) ])
    end

    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.total'), total_demand ])

    xls_add_empty_rows(sheet)
    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.organs_demand') ])

    total_demand = presenter.organs_demand_count.values.sum
    presenter.organs_demand_count.each do |organ, demand|
      xls_add_row(sheet, [ organ, demand, presenter.calc_percentage(demand, total_demand) ])
    end

    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sic.organ.total'), total_demand ])
  end

  def sheet_type
    :organ
  end
end
