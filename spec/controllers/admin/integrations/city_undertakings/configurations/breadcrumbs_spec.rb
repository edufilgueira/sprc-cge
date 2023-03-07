require 'rails_helper'

describe Admin::Integrations::CityUndertakings::ConfigurationsController do

  let(:integration_id) { :city_undertakings }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
