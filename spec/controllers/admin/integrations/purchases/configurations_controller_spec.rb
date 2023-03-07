require 'rails_helper'

describe Admin::Integrations::Purchases::ConfigurationsController do

  let(:integration_id) { :purchases }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :wsdl,
      :operation,
      :response_path,
      :month,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
