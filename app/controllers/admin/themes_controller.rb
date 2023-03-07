class Admin::ThemesController < Admin::BaseCrudController
  include Admin::Themes::Breadcrumbs
  include ToggleDisabledController
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :code
  ]

  SORT_COLUMNS = {
    code: 'themes.code',
    name: 'themes.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['toggle_disabled']

  helper_method [:themes, :theme]


  # Helper methods

  def themes
    paginated_resources
  end

  def theme
    resource
  end
end
