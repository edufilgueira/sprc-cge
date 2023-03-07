class Admin::Integrations::Expenses::NedsController < AdminController
  include Admin::Integrations::Expenses::Neds::Breadcrumbs
  include Transparency::Expenses::Neds::BaseController

end
