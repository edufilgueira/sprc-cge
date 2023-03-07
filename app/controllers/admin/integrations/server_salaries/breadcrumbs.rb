module Admin::Integrations::ServerSalaries::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t("shared.transparency.server_salaries.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t("shared.transparency.server_salaries.index.title"), admin_integrations_server_salaries_path],
      [server_salary.title, '']
    ]
  end
end
