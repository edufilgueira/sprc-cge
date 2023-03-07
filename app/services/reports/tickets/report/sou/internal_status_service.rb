class Reports::Tickets::Report::Sou::InternalStatusService < Reports::Tickets::Report::BaseService
  include Reports::Tickets::Report::InternalStatus::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sou::InternalStatusPresenter.new(default_scope, ticket_report)
  end
end
