class Admin::Integrations::RealStates::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::RealStates::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
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
