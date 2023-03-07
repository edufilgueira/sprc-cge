# RESTful API pública de Unidades (Department)
#
# 1) INDEX
#    GET /api/v1/departments
#    HTTP 200 - [ { role }, { role }, ... ]
#
class Api::V1::DepartmentsController < Api::V1::ApplicationController
  include FilteredController

  FILTERED_ASSOCIATIONS = [
    :organ_id,
    :subnet_id
  ]

  # Actions

  def index
    object_response(departments)
  end

  # Privates

  private

  def departments
    filtered_departments
  end

  def filtered_departments
    filtered(::Department, sorted_departments)
  end

  def sorted_departments
    resources.sorted
  end

  def resources
    @resources ||= Department.enabled
  end
end
