class Admin::Integrations::Expenses::NpfsController < AdminController
  include Admin::Integrations::Expenses::Npfs::Breadcrumbs
  include Transparency::Expenses::Npfs::BaseController

end
