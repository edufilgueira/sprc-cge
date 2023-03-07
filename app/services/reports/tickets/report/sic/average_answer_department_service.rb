class Reports::Tickets::Report::Sic::AverageAnswerDepartmentService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::AverageAnswerDepartment::BaseService

  private

  def scope
    report_scope
  end
end
