class AddKeepSecretToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :keep_secret, :boolean, default: false
  end
end
