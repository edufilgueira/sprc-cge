class RenameIntegrationServersToIntegrationServersConfigurations < ActiveRecord::Migration[5.0]
  def change
    rename_table :integration_servers, :integration_servers_configurations
  end
end
