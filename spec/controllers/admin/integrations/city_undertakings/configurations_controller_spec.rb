require 'rails_helper'

describe Admin::Integrations::CityUndertakings::ConfigurationsController do

  let(:integration_id) { :city_undertakings }
  let(:custom_integration_id_locale) { :city_undertakings }

  let(:permitted_params) do
    [
      :headers_soap_action,
      :user,
      :password,
      :wsdl,
      :undertaking_operation,
      :undertaking_response_path,
      :city_undertaking_operation,
      :city_undertaking_response_path,
      :city_organ_operation,
      :city_organ_response_path,
      :month,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
