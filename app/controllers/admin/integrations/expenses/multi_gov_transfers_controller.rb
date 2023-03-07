class Admin::Integrations::Expenses::MultiGovTransfersController < AdminController
  include Admin::Integrations::Expenses::MultiGovTransfers::Breadcrumbs
  include Transparency::Expenses::MultiGovTransfers::BaseController

end
