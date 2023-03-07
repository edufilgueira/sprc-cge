require 'rails_helper'

describe Admin::Integrations::Eparcerias::ConfigurationsController do

  let(:integration_id) { :eparcerias }

  let(:permitted_params) do
    [
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

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
