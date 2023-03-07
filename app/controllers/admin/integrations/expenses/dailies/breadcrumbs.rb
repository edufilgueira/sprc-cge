module Admin::Integrations::Expenses::Dailies::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t('admin.integrations.expenses.index.title'), admin_integrations_expenses_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t('admin.integrations.expenses.index.title'), admin_integrations_expenses_root_path],
      [t('admin.integrations.expenses.dailies.index.title'), admin_integrations_expenses_dailies_path],
      [daily.title, '']
    ]
  end
end
