class AddAccountConfigurationToIntegrationRevenuesRevenue < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_revenues, :integration_revenues_account_configuration_id, :integer
    add_index :integration_revenues_revenues, :integration_revenues_account_configuration_id, name: "index_revenues_on_account_configuration_id"

  end
end
