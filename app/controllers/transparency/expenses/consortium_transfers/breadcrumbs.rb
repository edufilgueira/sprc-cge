module Transparency::Expenses::ConsortiumTransfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.consortium_transfers.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.consortium_transfers.index.title'), transparency_expenses_consortium_transfers_path],
      [consortium_transfer.title, '']
    ]
  end
end
