class Admin::Integrations::MacroregionInvestiments::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::MacroregionInvestiments::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :headers_soap_action,
    :user,
    :password,
    :wsdl,
    :operation,
    :response_path,
    :year,
    :power,
    schedule_attributes: [:id, :cron_syntax_frequency]
  ]

  def resource_klass
    Integration::Macroregions::Configuration
  end
end
