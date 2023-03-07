class Reports::Tickets::GrossExport::SicService < Reports::Tickets::GrossExport::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::GrossExport::SicPresenter.new(default_scope, gross_export.id)
  end

  def sheet_type
    :sic
  end
end
