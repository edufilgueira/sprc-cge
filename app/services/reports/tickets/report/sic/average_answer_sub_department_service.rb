class Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService < Reports::Tickets::Report::Sic::BaseService
  include Reports::Tickets::Report::AverageAnswerSubDepartment::BaseService

  private

  def scope
    @scope ||= report_scope.without_other_organs
  end
end
