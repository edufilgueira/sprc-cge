class Reports::Tickets::GrossExport::SouService < Reports::Tickets::GrossExport::BaseService
  private

  def presenter
    @presenter ||= Reports::Tickets::GrossExport::SouPresenter.new(default_scope, gross_export.id)
  end

  def sheet_type
    :sou
  end
end
