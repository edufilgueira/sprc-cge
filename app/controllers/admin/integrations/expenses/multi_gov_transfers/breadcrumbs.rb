module Admin::Integrations::Expenses::MultiGovTransfers::Breadcrumbs
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
      [t('admin.integrations.expenses.multi_gov_transfers.index.title'), admin_integrations_expenses_multi_gov_transfers_path],
      [multi_gov_transfer.title, '']
    ]
  end
end
