require 'rails_helper'

describe Admin::Integrations::Servers::ConfigurationsController do

  let(:integration_id) { :servers }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
