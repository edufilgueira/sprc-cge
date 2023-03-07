require 'rails_helper'

describe Admin::Integrations::Revenues::ConfigurationsController do

  let(:integration_id) { :revenues }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :wsdl,
      :user,
      :password,
      :operation,
      :response_path,
      :month,
      account_configurations_attributes: [
        :id, :account_number, :title, :_destroy
      ],
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
