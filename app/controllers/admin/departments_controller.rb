class Admin::DepartmentsController < Admin::BaseCrudController
  include Admin::Departments::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled
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

  FILTERED_ASSOCIATIONS = [:organ, :subnet]

  SORT_COLUMNS = {
    organ_acronym: 'organs.acronym',
    subnet_acronym: 'subnets.acronym',
    acronym: 'departments.acronym',
    name: 'departments.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:departments, :department, :sub_departments]


  # Helper methods

  def departments
    paginated_resources
  end

  def department
    resource
  end

  def sub_departments
    department.sub_departments.sorted
  end
end
