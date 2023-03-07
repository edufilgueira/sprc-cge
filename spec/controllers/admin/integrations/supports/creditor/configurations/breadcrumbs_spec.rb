require 'rails_helper'

describe Admin::Integrations::Supports::Creditor::ConfigurationsController do

  let(:integration_id) { :supports_creditor }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
