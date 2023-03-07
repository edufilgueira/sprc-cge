class Admin::Integrations::CityUndertakingsController < AdminController
  include Transparency::CityUndertakings::BaseController
  include Admin::Integrations::CityUndertakings::Breadcrumbs
end
