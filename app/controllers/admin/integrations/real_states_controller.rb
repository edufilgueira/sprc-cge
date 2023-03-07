class Admin::Integrations::RealStatesController < AdminController
  include Transparency::RealStates::BaseController
  include Admin::Integrations::RealStates::Breadcrumbs

end
