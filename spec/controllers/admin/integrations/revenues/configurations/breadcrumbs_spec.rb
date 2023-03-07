require 'rails_helper'

describe Admin::Integrations::Revenues::ConfigurationsController  do

  let(:integration_id) { :revenues }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
