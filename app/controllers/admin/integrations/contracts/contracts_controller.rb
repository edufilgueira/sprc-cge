class Admin::Integrations::Contracts::ContractsController < AdminController
  include Transparency::Contracts::Contracts::BaseController
  include Admin::Integrations::Contracts::Contracts::Breadcrumbs

end
