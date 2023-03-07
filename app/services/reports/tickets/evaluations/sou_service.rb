class Reports::Tickets::Evaluations::SouService < Reports::Tickets::Evaluations::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Evaluations::SouPresenter.new(default_scope)
  end

  def sheet_type
    :sou
  end
end

