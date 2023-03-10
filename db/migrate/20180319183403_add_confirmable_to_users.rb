class AddConfirmableToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # reconfirmable

    add_index :users, :confirmation_token, unique: true

    # Todos os usuários existentes serão considerados confirmados
    execute <<~SQL
      UPDATE users SET confirmed_at = created_at;
    SQL
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_columns :users, :unconfirmed_email # reconfirmable
  end
end
