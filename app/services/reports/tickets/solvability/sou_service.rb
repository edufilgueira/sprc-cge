class Reports::Tickets::Solvability::SouService < Reports::Tickets::Solvability::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::SolvabilityPresenter.new(default_scope, solvability_report)
  end
end
