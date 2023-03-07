require 'rails_helper'

describe Admin::Integrations::Supports::Theme::ConfigurationsController do
  let(:integration_id) { :supports_theme }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
