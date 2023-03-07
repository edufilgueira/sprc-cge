class Admin::Integrations::Expenses::BudgetBalancesController < AdminController
  include Admin::Integrations::Expenses::BudgetBalances::Breadcrumbs
  include Transparency::Expenses::BudgetBalances::BaseController

end
