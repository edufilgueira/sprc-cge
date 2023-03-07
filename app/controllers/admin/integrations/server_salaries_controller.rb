class Admin::Integrations::ServerSalariesController < AdminController
  include Transparency::ServerSalaries::BaseController
  include Admin::Integrations::ServerSalaries::Breadcrumbs

end
