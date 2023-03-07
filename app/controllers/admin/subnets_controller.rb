class Admin::SubnetsController < Admin::BaseCrudController
  include Admin::Subnets::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :acronym,
    :organ_id,
    :ignore_sectoral_validation
  ]

  FILTERED_ASSOCIATIONS = [:organ]

  SORT_COLUMNS = {
    organ_acronym: 'organs.acronym',
    acronym: 'subnets.acronym',
    name: 'subnets.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:subnets, :subnet]

  # Helper methods

  def subnets
    paginated_resources
  end

  def subnet
    resource
  end
end
