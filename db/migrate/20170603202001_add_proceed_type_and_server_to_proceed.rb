class AddProceedTypeAndServerToProceed < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_proceeds, :integration_servers_server_id, :integer
    add_index :integration_servers_proceeds, :integration_servers_server_id, name: 'index_proceeds_on_server_id'
    add_column :integration_servers_proceeds, :integration_servers_proceed_type_id, :integer
    add_index :integration_servers_proceeds, :integration_servers_proceed_type_id, name: 'index_proceeds_on_proceed_type_id'
  end
end
