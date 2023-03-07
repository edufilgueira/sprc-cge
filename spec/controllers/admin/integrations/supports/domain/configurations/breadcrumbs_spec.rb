require 'rails_helper'

describe Admin::Integrations::Supports::Domain::ConfigurationsController do

  let(:integration_id) { :supports_domain }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
