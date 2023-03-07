class Admin::Integrations::Supports::ThemesController < AdminController
  include Admin::Integrations::Supports::Themes::Breadcrumbs
  include ::PaginatedController
  include ::SortedController
  include ::FilteredController

  SORT_COLUMNS = [
    'integration_supports_themes.codigo_tema',
    'integration_supports_themes.descricao_tema'
  ]

  helper_method [:themes, :theme]

  # Helper methods

  def themes
    paginated_themes
  end

  def theme
    resource
  end


  # Private

  private

  def paginated_themes
    paginated(filtered_themes)
  end

  def filtered_themes
    filtered(Integration::Supports::Theme, sorted_themes)
  end

  def sorted_themes
    resources.sorted(sort_column, sort_direction)
  end

  def default_sort_column
    Integration::Supports::Theme.default_sort_column
  end

  def default_sort_direction
    Integration::Supports::Theme.default_sort_direction
  end

  def resource_klass
    Integration::Supports::Theme
  end
end
