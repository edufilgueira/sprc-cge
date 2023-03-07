class Reports::Tickets::Report::Sic::SubtopicService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::Subtopic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::SubtopicPresenter.new(report_scope, ticket_report)
  end
end
