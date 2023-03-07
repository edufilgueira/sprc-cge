class AddUnknownOrganToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :unknown_organ, :boolean
    add_index :tickets, :unknown_organ
  end
end
