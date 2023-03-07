class Admin::ServiceTypesController < Admin::BaseCrudController
  include Admin::ServiceTypes::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :organ_id,
    :code,
    :subnet_id
  ]

  FILTERED_ASSOCIATIONS = [:organ, :subnet]

  SORT_COLUMNS = {
    organ_acronym: 'organs.acronym',
    name: 'service_types.name',
    code: 'service_types.code'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:service_types, :service_type]

  def service_types
    paginated_resources
  end

  def service_type
    resource
  end
end
