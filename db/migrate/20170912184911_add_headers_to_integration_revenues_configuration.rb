class AddHeadersToIntegrationRevenuesConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_configurations, :headers_soap_action, :string
    remove_column :integration_revenues_configurations, :endpoint, :string
  end
end
