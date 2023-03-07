class Reports::Tickets::GrossExport::SummaryService < Reports::Tickets::GrossExport::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::GrossExport::SummaryPresenter.new(default_scope, gross_export)
  end

  def build_sheet(sheet)
    add_header(sheet)

    xls_add_row(sheet, [ presenter.name_report ])
    xls_add_row(sheet, [ presenter.created_by ])
    xls_add_row(sheet, [ presenter.created_at ])
    xls_add_row(sheet, [ presenter.creator_email ])
    xls_add_row(sheet, [ presenter.operator_type ])
    xls_add_row(sheet, [ presenter.tickets_count ])
    xls_add_row(sheet, [ presenter.tickets_invalidate_count ])
    xls_add_row(sheet, [ presenter.tickets_other_organs_count ])
    xls_add_row(sheet, [ presenter.tickets_reopened_count ])
  end

  def add_header(sheet)
    xls_add_header(sheet, [ header_title ])
  end

  def sheet_type
    :summary
  end

  def header_title
    I18n.t("services.reports.tickets.gross_export.summary.title", begin: beginning_date.to_s, end: end_date.to_s)
  end
end
