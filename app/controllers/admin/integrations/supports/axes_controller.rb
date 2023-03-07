class Admin::Integrations::Supports::AxesController < Admin::BaseCrudController
  include Admin::Integrations::Supports::Axes::Breadcrumbs

  SORT_COLUMNS = [
    'integration_supports_axes.codigo_eixo',
    'integration_supports_axes.descricao_eixo'
  ]

  helper_method [ :axes, :axis ]

  # Helper methods

  def axes
    # Os recursos paginados já são filtrados e ordenados.
    paginated_resources
  end

  def axis
    resource
  end

  # Private

  private

  def resource_klass
    Integration::Supports::Axis
  end
end
