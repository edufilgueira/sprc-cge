module Transparency::Expenses::CityTransfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.city_transfers.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.city_transfers.index.title'), transparency_expenses_city_transfers_path],
      [city_transfer.title, '']
    ]
  end
end
