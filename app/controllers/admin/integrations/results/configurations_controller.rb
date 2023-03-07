class Admin::Integrations::Results::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Results::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :headers_soap_action,
    :user,
    :password,
    :wsdl,
    :strategic_indicator_operation,
    :strategic_indicator_response_path,
    :thematic_indicator_operation,
    :thematic_indicator_response_path,
    schedule_attributes: [:id, :cron_syntax_frequency]
  ]
end
