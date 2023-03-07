require 'rails_helper'

describe Admin::Integrations::Constructions::ConfigurationsController do

  let(:integration_id) { :constructions }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :der_wsdl,
      :dae_wsdl,
      :der_operation,
      :der_response_path,
      :dae_operation,
      :dae_response_path,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
