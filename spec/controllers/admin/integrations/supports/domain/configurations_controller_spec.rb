require 'rails_helper'

describe Admin::Integrations::Supports::Domain::ConfigurationsController do

  let(:integration_id) { :supports_domain }

  let(:permitted_params) do
    [
      :wsdl,
      :headers_soap_action,
      :user,
      :password,
      :started_at,
      :finished_at,
      :operation,
      :response_path,
      :year,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
