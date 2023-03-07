class RemoveKeepSecretToTickets < ActiveRecord::Migration[5.0]
  def up
    remove_column :tickets, :keep_secret
  end

  def down
    add_column :tickets, :keep_secret, :boolean
  end
end
