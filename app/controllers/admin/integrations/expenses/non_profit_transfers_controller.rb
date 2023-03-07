class Admin::Integrations::Expenses::NonProfitTransfersController < AdminController
  include Admin::Integrations::Expenses::NonProfitTransfers::Breadcrumbs
  include Transparency::Expenses::NonProfitTransfers::BaseController

end
