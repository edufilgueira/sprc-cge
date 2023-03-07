class Admin::Integrations::Contracts::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Contracts::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :headers_soap_action,
    :wsdl,
    :user,
    :password,
    :start_at,
    :end_at,
    :contract_operation,
    :contract_response_path,
    :contract_parameters,
    :additive_operation,
    :additive_response_path,
    :additive_parameters,
    :adjustment_operation,
    :adjustment_response_path,
    :adjustment_parameters,
    :financial_operation,
    :financial_response_path,
    :financial_parameters,
    :infringement_operation,
    :infringement_response_path,
    :infringement_parameters,
    schedule_attributes: [:id, :cron_syntax_frequency]
  ]
end
