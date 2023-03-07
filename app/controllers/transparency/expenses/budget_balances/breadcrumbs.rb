module Transparency::Expenses::BudgetBalances::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.expenses.budget_balances.index.title'), '']
    ]
  end
end
