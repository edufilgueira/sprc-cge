# RESTful API pública de Sub-unidades (SubDepartment)
#
# 1) INDEX
#    GET /api/v1/sub_departments
#    HTTP 200 - [ { role }, { role }, ... ]
#
class Api::V1::SubDepartmentsController < Api::V1::ApplicationController
  include FilteredController

  FILTERED_ASSOCIATIONS = [
    :department_id
  ]

  # Actions

  def index
    object_response(sub_departments)
  end

  # Privates

  private

  def sub_departments
    filtered_sub_departments
  end

  def filtered_sub_departments
    filtered(::SubDepartment, sorted_sub_departments)
  end

  def sorted_sub_departments
    resources.sorted
  end

  def resources
    @resources ||= sub_departments_from_department
  end

  def sub_departments_from_department
    if department.present?
      department.sub_departments.enabled
    else
      SubDepartment.enabled
    end
  end

  def department
    @department ||= Department.find(params[:department_id]) if params[:department_id].present? && params[:department_id] != '0'
  end
end
