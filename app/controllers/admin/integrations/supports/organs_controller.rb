class Admin::Integrations::Supports::OrgansController < AdminController
  include Admin::Integrations::Supports::Organs::Breadcrumbs
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

  SORT_COLUMNS = [
    'integration_supports_organs.codigo_entidade',
    'integration_supports_organs.descricao_entidade',
    'integration_supports_organs.codigo_orgao',
    'integration_supports_organs.sigla',
    'integration_supports_organs.descricao_orgao',
    'integration_supports_organs.data_inicio',
    'integration_supports_organs.data_termino',
    'integration_supports_organs.orgao_sfp'
  ]

  helper_method [:organs, :organ]

  # Helper methods

  def organs
    paginated_organs
  end

  def organ
    resource
  end


  # Private

  private

  def paginated_organs
    paginated(filtered_organs)
  end

  def filtered_organs
    filtered(Integration::Supports::Organ, sorted_organs)
  end

  def sorted_organs
    resources.sorted(sort_column, sort_direction)
  end

  def default_sort_column
    Integration::Supports::Organ.default_sort_column
  end

  def default_sort_direction
    Integration::Supports::Organ.default_sort_direction
  end

  def resource_klass
    Integration::Supports::Organ
  end

end
