class Admin::Integrations::Expenses::DailiesController < AdminController
  include Admin::Integrations::Expenses::Dailies::Breadcrumbs
  include Transparency::Expenses::Dailies::BaseController

end
