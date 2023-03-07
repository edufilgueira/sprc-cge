class CreateIntegrationServers < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers do |t|
      t.string :arqfun_ftp_address, null: false
      t.string :arqfun_ftp_user, null: false
      t.string :arqfun_ftp_password, null: false
      t.string :arqfin_ftp_address, null: false
      t.string :arqfin_ftp_user, null: false
      t.string :arqfin_ftp_password, null: false
      t.string :rubricas_ftp_address, null: false
      t.string :rubricas_ftp_user, null: false
      t.string :rubricas_ftp_password, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
