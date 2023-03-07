class Admin::Integrations::Contracts::ConvenantsController < AdminController
  include Transparency::Contracts::Convenants::BaseController
  include Admin::Integrations::Contracts::Convenants::Breadcrumbs

end
