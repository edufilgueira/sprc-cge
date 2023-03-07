module Admin::Integrations::Supports::Themes::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t('admin.integrations.supports.themes.index.title'), admin_integrations_supports_themes_path],
      [theme.title.to_s.truncate(20), '']
    ]
  end
end
