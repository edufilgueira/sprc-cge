module Transparency::Expenses::MultiGovTransfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.multi_gov_transfers.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.multi_gov_transfers.index.title'), transparency_expenses_multi_gov_transfers_path],
      [multi_gov_transfer.title, '']
    ]
  end
end
