require 'rails_helper'

describe Admin::Integrations::MacroregionInvestiments::ConfigurationsController do
  let(:integration_id) { :macroregions }

  let(:custom_integration_id_locale) { :macroregion_investiments }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :wsdl,
      :operation,
      :response_path,
      :year,
      :power,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
