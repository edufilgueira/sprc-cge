class AddTicketTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :ticket_type, :integer, default: 1
    add_index :tickets, :ticket_type
  end
end
