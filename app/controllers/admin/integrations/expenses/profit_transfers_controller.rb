class Admin::Integrations::Expenses::ProfitTransfersController < AdminController
  include Admin::Integrations::Expenses::ProfitTransfers::Breadcrumbs
  include Transparency::Expenses::ProfitTransfers::BaseController

end
