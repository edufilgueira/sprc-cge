class Reports::Attendances::SummaryService < Reports::Attendances::BaseService

  private

  def presenter
    @presenter ||= Reports::Attendances::SummaryPresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_row(sheet, [ total_sou_str, presenter.total_sou_count ])
    xls_add_row(sheet, [ total_sic_str, presenter.total_sic_count ])
  end

  def sheet_type
    :summary
  end

  def header_title
    I18n.t("services.reports.attendances.summary.title", begin: beginning_date.to_s, end: end_date.to_s)
  end

  def total_sou_str
    I18n.t('services.reports.attendances.summary.total.sou')
  end

  def total_sic_str
    I18n.t('services.reports.attendances.summary.total.sic')
  end
end

