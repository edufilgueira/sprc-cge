class AddAnonymousToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :anonymous, :boolean
    add_index :tickets, :anonymous
  end
end
