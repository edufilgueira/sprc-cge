class DropIntegrationServers < ActiveRecord::Migration[5.0]
  def up
    drop_table :integration_servers_proceed_types
    drop_table :integration_servers_proceeds
    drop_table :integration_servers_servers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
