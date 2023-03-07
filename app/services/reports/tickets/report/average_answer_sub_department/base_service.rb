module Reports::Tickets::Report::AverageAnswerSubDepartment::BaseService
  include Reports::Tickets::Report::AverageAnswerDepartment::BaseService
  extend ActiveSupport::Concern

  included do

    private

    def presenter
      @presenter ||= Reports::Tickets::AverageAnswerSubDepartmentPresenter.new(scope)
    end

    def scope
      @scope ||= default_scope.without_other_organs.without_characteristic
    end

    def sheet_type
      :average_answer_sub_department
    end

    def resource_scope
      sub_departments_ids = scope.joins(ticket_departments: :ticket_department_sub_departments)
        .where(ticket_departments: {answer: :answered})
        .group('ticket_department_sub_departments.sub_department_id').count.map{|i,_| i}
      @resource_scope ||= SubDepartment.where(id: sub_departments_ids)
    end
  end
end
