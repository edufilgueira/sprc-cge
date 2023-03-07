class AddDirColumnsToIntegrationServers < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers, :arqfun_ftp_dir, :string
    add_column :integration_servers, :arqfin_ftp_dir, :string
    add_column :integration_servers, :rubricas_ftp_dir, :string
  end
end
