require 'rails_helper'

describe Admin::Integrations::Results::ConfigurationsController do

  let(:integration_id) { :results }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
