module Transparency::Expenses::NonProfitTransfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.non_profit_transfers.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.non_profit_transfers.index.title'), transparency_expenses_non_profit_transfers_path],
      [non_profit_transfer.title, '']
    ]
  end
end
