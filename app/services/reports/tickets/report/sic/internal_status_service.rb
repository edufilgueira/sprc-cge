class Reports::Tickets::Report::Sic::InternalStatusService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::InternalStatus::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Sic::InternalStatusPresenter.new(report_scope, ticket_report)
  end
end
