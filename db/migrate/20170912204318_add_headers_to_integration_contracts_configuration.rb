class AddHeadersToIntegrationContractsConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_contracts_configurations, :headers_soap_action, :string
    remove_column :integration_contracts_configurations, :endpoint, :string
  end
end
