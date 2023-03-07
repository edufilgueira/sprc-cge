require 'rails_helper'

describe Admin::Integrations::Eparcerias::ConfigurationsController  do

  let(:integration_id) { :eparcerias }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
