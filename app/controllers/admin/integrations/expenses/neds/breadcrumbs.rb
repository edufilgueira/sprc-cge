module Admin::Integrations::Expenses::Neds::Breadcrumbs
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
    integrations_index_breadcrumbs +
    [
      [t('admin.integrations.expenses.index.title'), admin_integrations_expenses_root_path],
      [t('admin.integrations.expenses.neds.index.title'), admin_integrations_expenses_neds_path],
      [ned.title, '']
    ]
  end
end

