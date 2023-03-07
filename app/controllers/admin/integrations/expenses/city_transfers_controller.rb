class Admin::Integrations::Expenses::CityTransfersController < AdminController
  include Admin::Integrations::Expenses::CityTransfers::Breadcrumbs
  include Transparency::Expenses::CityTransfers::BaseController

end
