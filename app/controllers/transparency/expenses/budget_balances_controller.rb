class Transparency::Expenses::BudgetBalancesController < TransparencyController
  include Transparency::Expenses::BudgetBalances::BaseController
  include Transparency::Expenses::BudgetBalances::Breadcrumbs

end
