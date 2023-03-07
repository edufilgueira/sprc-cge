class Admin::Integrations::CityUndertakings::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::CityUndertakings::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
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
