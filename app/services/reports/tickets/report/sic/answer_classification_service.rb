class Reports::Tickets::Report::Sic::AnswerClassificationService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::AnswerClassification::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::AnswerClassificationPresenter.new(report_scope, ticket_report)
  end
end
