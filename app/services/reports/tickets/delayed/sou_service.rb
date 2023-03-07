class Reports::Tickets::Delayed::SouService < Reports::Tickets::Delayed::BaseService

  private

  def sou_scope
    default_scope.sou
  end

  def presenter
    @presenter ||= Reports::Tickets::Delayed::SouPresenter.new(sou_scope)
  end

  def sheet_type
    :sou
  end
end
