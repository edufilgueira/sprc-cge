class AddPassiveColumnsToIntegrationServers < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers, :arqfun_ftp_passive, :boolean, null: false, default: false
    add_column :integration_servers, :arqfin_ftp_passive, :boolean, null: false, default: false
    add_column :integration_servers, :rubricas_ftp_passive, :boolean, null: false, default: false
  end
end
