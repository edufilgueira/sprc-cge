class Admin::RedeOuvirOrgansController < Admin::BaseCrudController
  include Admin::RedeOuvirOrgans::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :acronym,
    :description,
    :code,
    :subnet,
    :ignore_cge_validation
  ]

  SORT_COLUMNS = {
    acronym: 'organs.acronym',
    name: 'organs.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:rede_ouvir_organs, :rede_ouvir_organ]


  # Helper methods

  def rede_ouvir_organs
    paginated_resources
  end

  def rede_ouvir_organ

    #
    # Padrão é ignorar validação da CGE em órgãos da Rede Ouvir.
    #
    if resource.new_record? && params[:ignore_cge_validation].blank?
      resource.ignore_cge_validation = true
    end

    resource
  end
end
