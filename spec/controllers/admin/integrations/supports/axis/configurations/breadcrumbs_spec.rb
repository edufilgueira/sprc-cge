require 'rails_helper'

describe Admin::Integrations::Supports::Axis::ConfigurationsController do
  let(:integration_id) { :supports_axis }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
