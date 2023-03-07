class CreateRedeOuvirOmbudsmanEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :rede_ouvir_ombudsman_emails do |t|
      t.integer :ticket_id, index: true
      t.string :token, index: true
      t.string :email

      t.timestamps
    end
  end
end
