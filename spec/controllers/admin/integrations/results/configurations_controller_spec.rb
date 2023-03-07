require 'rails_helper'

describe Admin::Integrations::Results::ConfigurationsController do

  let(:integration_id) { :results }
  let(:custom_integration_id_locale) { :results }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :wsdl,
      :strategic_indicator_operation,
      :strategic_indicator_response_path,
      :thematic_indicator_operation,
      :thematic_indicator_response_path,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
