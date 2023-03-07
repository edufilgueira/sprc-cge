class Reports::Tickets::Report::Sic::TopicService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::Topic::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::TopicPresenter.new(report_scope, ticket_report)
  end
end
