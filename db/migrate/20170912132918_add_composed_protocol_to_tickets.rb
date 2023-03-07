class AddComposedProtocolToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :composed_protocol, :string
    add_index :tickets, :composed_protocol, unique: true
  end
end
