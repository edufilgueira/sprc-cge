class DeviseCreateRedeOuvirUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :rede_ouvir_users do |t|
      t.string :name, null: false
      t.string :cpf, null: false

      # paranoia
      t.datetime :deleted_at, index: true

      # DEVISE ATTRS
      # ----

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.datetime :disabled_at


      t.timestamps null: false
    end

    # XXX customizando para uso de paranoia (deleted_at) na unicidade
    add_index :rede_ouvir_users, [:email, :deleted_at], unique: true
    add_index :rede_ouvir_users, :reset_password_token, unique: true
    add_index :rede_ouvir_users, :confirmation_token,   unique: true
    # add_index :rede_ouvir_users, :unlock_token,         unique: true

    # índices extras
    add_index :rede_ouvir_users, [:cpf, :deleted_at], unique: true

    add_reference :rede_ouvir_users, :ombudsman, foreign_key: { to_table: :rede_ouvir_ombudsmen }
  end
end
