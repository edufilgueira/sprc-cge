module Admin::Integrations::Revenues::Accounts::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t('shared.transparency.revenues.accounts.index.title'), '']
    ]
  end
end
