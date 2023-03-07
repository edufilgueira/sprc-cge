module Transparency::Expenses::FundSupplies::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.fund_supplies.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.fund_supplies.index.title'), transparency_expenses_fund_supplies_path],
      [fund_supply.title, '']
    ]
  end
end
