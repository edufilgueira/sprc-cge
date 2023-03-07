require 'rails_helper'

describe Admin::Integrations::Supports::Organ::ConfigurationsController do

  let(:integration_id) { :supports_organ }

  let(:permitted_params) do
    [
      :wsdl,
      :headers_soap_action,
      :user,
      :password,
      :operation,
      :response_path,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
