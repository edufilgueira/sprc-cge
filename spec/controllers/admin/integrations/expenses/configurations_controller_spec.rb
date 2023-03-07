require 'rails_helper'

describe Admin::Integrations::Expenses::ConfigurationsController do

  let(:integration_id) { :expenses }

  let(:permitted_params) do
    [
      :npf_wsdl,
      :npf_headers_soap_action,
      :npf_operation,
      :npf_response_path,
      :npf_user,
      :npf_password,
      :ned_wsdl,
      :ned_headers_soap_action,
      :ned_operation,
      :ned_response_path,
      :ned_user,
      :ned_password,
      :nld_wsdl,
      :nld_headers_soap_action,
      :nld_operation,
      :nld_response_path,
      :nld_user,
      :nld_password,
      :npd_wsdl,
      :npd_headers_soap_action,
      :npd_operation,
      :npd_response_path,
      :npd_user,
      :npd_password,
      :budget_balance_wsdl,
      :budget_balance_headers_soap_action,
      :budget_balance_operation,
      :budget_balance_response_path,
      :budget_balance_user,
      :budget_balance_password,
      :started_at,
      :finished_at,
      schedule_attributes: [:id, :cron_syntax_frequency]
    ]
  end

  it_behaves_like 'controllers/admin/integrations/configurations/crud'
end
