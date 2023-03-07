module Admin::Integrations::Contracts::Convenants::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t("shared.transparency.contracts.convenants.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t("shared.transparency.contracts.convenants.index.title"), admin_integrations_contracts_convenants_path],
      [convenant.title, '']
    ]
  end
end
