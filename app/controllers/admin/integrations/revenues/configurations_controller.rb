class Admin::Integrations::Revenues::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Revenues::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
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
