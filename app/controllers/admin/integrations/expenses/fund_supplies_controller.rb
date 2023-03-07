class Admin::Integrations::Expenses::FundSuppliesController < AdminController
  include Admin::Integrations::Expenses::FundSupplies::Breadcrumbs
  include Transparency::Expenses::FundSupplies::BaseController

end
