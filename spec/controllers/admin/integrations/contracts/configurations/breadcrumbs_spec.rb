require 'rails_helper'

describe Admin::Integrations::Contracts::ConfigurationsController  do

  let(:integration_id) { :contracts }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
