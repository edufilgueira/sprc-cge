class Admin::ExecutiveOrgansController < Admin::BaseCrudController
  include Admin::ExecutiveOrgans::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :acronym,
    :description,
    :code,
    :subnet,
    :ignore_cge_validation,
    organ_associations_attributes: [
      :id,
      :organ_association_id,
      :_destroy
    ]
  ]

  SORT_COLUMNS = {
    acronym: 'organs.acronym',
    name: 'organs.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:executive_organs, :executive_organ]


  # Helper methods

  def executive_organs
    paginated_resources
  end

  def executive_organ
    resource
  end
end
