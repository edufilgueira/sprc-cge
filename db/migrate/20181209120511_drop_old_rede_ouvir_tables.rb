class DropOldRedeOuvirTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :rede_ouvir_users
    drop_table :attendance_rede_ouvir_ombudsmen
    drop_table :rede_ouvir_ombudsman_emails
    drop_table :rede_ouvir_ombudsmen

    remove_column :tickets, :rede_ouvir_ombudsman_id
  end
end
