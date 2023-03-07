class Admin::BudgetProgramsController < Admin::BaseCrudController
  include Admin::BudgetPrograms::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled
  include OrganOrSubnetController

  PERMITTED_PARAMS = [
    :name,
    :code,
    :theme_id,
    :organ_id,
    :subnet_id
  ]

  FILTERED_ASSOCIATIONS = [:organ, :subnet]

  SORT_COLUMNS = {
    organ_acronym: 'organs.acronym',
    subnet_acronym: 'subnets.acronym',
    name: 'budget_programs.name',
    code: 'budget_programs.code',
    theme: 'themes.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:budget_programs, :budget_program]

  # Helper methods

  def budget_programs
    paginated_resources
  end

  def budget_program
    resource
  end
end
