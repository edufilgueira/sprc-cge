require 'rails_helper'

describe Admin::Integrations::MacroregionInvestiments::ConfigurationsController do

  let(:integration_id) { :macroregions }

  it_behaves_like 'controllers/admin/integrations/configurations/breadcrumbs'
end
