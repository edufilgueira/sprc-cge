class Reports::Tickets::Evaluations::SicService < Reports::Tickets::Evaluations::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Evaluations::SicPresenter.new(default_scope)
  end

  def sheet_type
    :sic
  end
end

