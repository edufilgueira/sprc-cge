class Admin::Integrations::Supports::Theme::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Supports::Theme::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :wsdl,
    :headers_soap_action,
    :user,
    :password,
    :started_at,
    :finished_at,
    :operation,
    :response_path,
    schedule_attributes: [:id, :cron_syntax_frequency]
  ]
end
