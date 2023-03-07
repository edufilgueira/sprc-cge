require 'rails_helper'

describe Admin::Integrations::Expenses::ConfigurationsController  do

  let(:integration_id) { :expenses }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
