class AddParentProtocolToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :parent_protocol, :string
    add_index :tickets, :parent_protocol
  end
end
