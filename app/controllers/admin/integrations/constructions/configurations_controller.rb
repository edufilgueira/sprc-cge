class Admin::Integrations::Constructions::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Constructions::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
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
