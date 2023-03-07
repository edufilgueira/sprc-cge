require 'rails_helper'

describe Admin::Integrations::Purchases::ConfigurationsController do

  let(:integration_id) { :purchases }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
