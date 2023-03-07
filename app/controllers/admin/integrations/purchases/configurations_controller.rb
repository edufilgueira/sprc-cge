class Admin::Integrations::Purchases::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Purchases::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
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
