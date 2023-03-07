class Admin::Integrations::Expenses::NldsController < AdminController
  include Admin::Integrations::Expenses::Nlds::Breadcrumbs
  include Transparency::Expenses::Nlds::BaseController

end
