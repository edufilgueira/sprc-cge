class Admin::Integrations::Supports::Organ::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Supports::Organ::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :wsdl,
    :headers_soap_action,
    :user,
    :password,
    :operation,
    :response_path,
    schedule_attributes: [:id, :cron_syntax_frequency]
  ]
end
