require 'rails_helper'

describe Admin::Integrations::RealStates::ConfigurationsController do

  let(:integration_id) { :real_states }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
