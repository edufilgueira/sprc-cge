require 'rails_helper'

describe Admin::Integrations::RealStates::ConfigurationsController do

  let(:integration_id) { :real_states }
  let(:custom_integration_id_locale) { :real_states }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :wsdl,
      :operation,
      :response_path,
      :detail_operation,
      :detail_response_path,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
