module Admin::Integrations::Supports::Creditors::Breadcrumbs
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
      [t('admin.integrations.supports.creditors.index.title'), admin_integrations_supports_creditors_path],
      [creditor.title.to_s.truncate(20), '']
    ]
  end
end

