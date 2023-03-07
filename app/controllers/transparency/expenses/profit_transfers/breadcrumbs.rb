module Transparency::Expenses::ProfitTransfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.profit_transfers.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.profit_transfers.index.title'), transparency_expenses_profit_transfers_path],
      [profit_transfer.title, '']
    ]
  end
end
