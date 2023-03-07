class Reports::Tickets::Report::Sou::OrganService < Reports::Tickets::Report::BaseService

  def call
    return if ticket_report.user.sectoral?
    super
  end

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::OrganPresenter.new(default_scope, ticket_report)
  end

  def build_sheet(sheet)
    add_header(sheet)

    organs.find_each do |organ|
      organ_count = presenter.organ_count(organ)
      if organ_count.positive?
        xls_add_row(sheet, [ presenter.organ_str(organ), organ_count, presenter.organ_percentage(organ_count) ])
      end
    end

    xls_add_row(sheet, [ I18n.t('services.reports.tickets.sou.organ.total'), presenter.total_count ])

    xls_add_empty_rows(sheet)
    empty_label = I18n.t('services.reports.tickets.sou.organ.empty')
    xls_add_row(sheet, [ empty_label, presenter.organ_count(nil) ])
  end

  def sheet_type
    :organ
  end

  def organs
    organs = ExecutiveOrgan.all

    return organs unless ExecutiveOrgan.dpge.present?

    organs.where.not(id: ExecutiveOrgan.dpge)
  end
end
