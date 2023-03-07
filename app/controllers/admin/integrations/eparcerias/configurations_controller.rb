class Admin::Integrations::Eparcerias::ConfigurationsController < Admin::Integrations::BaseConfigurationsController
  include Admin::Integrations::Eparcerias::Configurations::Breadcrumbs

  PERMITTED_PARAMS = [
    :headers_soap_action,
    :user,
    :password,
    :wsdl,

    :import_type,

    :transfer_bank_order_operation,
    :transfer_bank_order_response_path,

    :work_plan_attachment_operation,
    :work_plan_attachment_response_path,

    :accountability_operation,
    :accountability_response_path,

    schedule_attributes: [:id, :cron_syntax_frequency]
  ]
end
