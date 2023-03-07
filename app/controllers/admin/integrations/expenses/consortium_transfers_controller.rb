class Admin::Integrations::Expenses::ConsortiumTransfersController < AdminController
  include Admin::Integrations::Expenses::ConsortiumTransfers::Breadcrumbs
  include Transparency::Expenses::ConsortiumTransfers::BaseController

end
