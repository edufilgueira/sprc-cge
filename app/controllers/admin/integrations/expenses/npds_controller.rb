class Admin::Integrations::Expenses::NpdsController < AdminController
  include Admin::Integrations::Expenses::Npds::Breadcrumbs
  include Transparency::Expenses::Npds::BaseController

end
