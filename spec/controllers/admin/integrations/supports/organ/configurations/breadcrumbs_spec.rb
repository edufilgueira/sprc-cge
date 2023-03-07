require 'rails_helper'

describe Admin::Integrations::Supports::Organ::ConfigurationsController  do

  let(:integration_id) { :supports_organ }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
