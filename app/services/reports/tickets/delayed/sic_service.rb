class Reports::Tickets::Delayed::SicService < Reports::Tickets::Delayed::BaseService

  private

  def sic_scope
    default_scope.sic
  end

  def presenter
    @presenter ||= Reports::Tickets::Delayed::SicPresenter.new(sic_scope)
  end

  def sheet_type
    :sic
  end
end
