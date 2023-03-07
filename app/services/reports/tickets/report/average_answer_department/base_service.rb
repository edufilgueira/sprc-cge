module Reports::Tickets::Report::AverageAnswerDepartment::BaseService
  extend ActiveSupport::Concern

  included do


    attr_reader :resource_scope

    private

    def presenter
      @presenter ||= Reports::Tickets::AverageAnswerDepartmentPresenter.new(scope)
    end

    def sheet_type
      :average_answer_department
    end

    def scope
      default_scope
    end

    def resource_scope
      @resource_scope ||= Department.where(id: departments_ids)
    end

    def departments_ids
      @departments_ids ||= scope.left_joins(ticket_departments: :ticket_department_sub_departments)
        .where(ticket_departments: {answer: :answered}, ticket_department_sub_departments: {id: nil})
        .group('ticket_departments.department_id').count.map{|i,_| i}
    end

    def build_sheet(sheet)
      add_header(sheet)

      resource_scope.each do |resource|
        xls_add_row(sheet, [
          organ_acronym(resource),
          resource.title,
          presenter.average_time(resource),
          presenter.amount_count(resource)
        ])
      end
    end

    def add_header(sheet)
      xls_add_header(sheet, headers)
    end

    def headers
      presenter.class::COLUMNS.map do |column|
        I18n.t("services.reports.tickets.#{ticket_report.ticket_type_filter}.#{sheet_type}.headers.#{column}")
      end
    end

    def organ_acronym(resource)
      return resource.organ_acronym if resource.respond_to?('organ_acronym')

      return resource.department_organ_acronym if resource.respond_to?('department_organ_acronym')
    end
  end
end
