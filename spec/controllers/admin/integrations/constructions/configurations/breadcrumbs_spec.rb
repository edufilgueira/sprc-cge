require 'rails_helper'

describe Admin::Integrations::Constructions::ConfigurationsController do

  let(:integration_id) { :constructions }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
