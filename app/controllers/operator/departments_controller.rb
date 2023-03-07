class Operator::DepartmentsController < OperatorController
  include Operator::Departments::Breadcrumbs
  include ::ToggleDisabledController
  include OrganOrSubnetController

  PERMITTED_PARAMS = [
    :name,
    :acronym,
    :organ_id,
    :subnet_id,
    sub_departments_attributes: [
      :id,
      :name,
      :acronym,
      :_disable
    ]
  ]

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:departments, :department, :sub_departments]


  # Helper methods

  def departments
    sorted_departments
  end

  def department
    resource
  end

  def sub_departments
    department.sub_departments.sorted
  end

  # Private

  private

  def departments_scope
    if current_user.subnet_operator?
      current_user.subnet.departments
    else
      current_user.organ.departments
    end
  end

  def sorted_departments
    departments_scope.enabled.sorted
  end

  def resource_klass
    Department
  end
end
