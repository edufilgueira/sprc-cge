class RemoveComposedProtocolTicket < ActiveRecord::Migration[5.0]
  def change
    remove_index :tickets, :composed_protocol
    remove_column :tickets, :composed_protocol, :string
    remove_column :tickets, :childs_count, :integer
  end
end
