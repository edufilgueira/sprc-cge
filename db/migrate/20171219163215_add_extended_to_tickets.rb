class AddExtendedToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :extended, :boolean, default: false
  end
end
