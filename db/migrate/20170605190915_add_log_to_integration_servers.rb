class AddLogToIntegrationServers < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers, :status, :integer
    add_column :integration_servers, :last_importation, :datetime
    add_column :integration_servers, :log, :string
  end
end
