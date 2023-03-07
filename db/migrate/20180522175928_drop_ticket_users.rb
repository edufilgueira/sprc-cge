class DropTicketUsers < ActiveRecord::Migration[5.0]
  def up
    drop_table :ticket_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
