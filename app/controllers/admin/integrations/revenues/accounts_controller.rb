class Admin::Integrations::Revenues::AccountsController < AdminController
  include Transparency::Revenues::Accounts::BaseController
  include Admin::Integrations::Revenues::Accounts::Breadcrumbs

end
