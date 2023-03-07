class AddMonthToIntegrationServersConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_configurations, :month, :string
  end
end
