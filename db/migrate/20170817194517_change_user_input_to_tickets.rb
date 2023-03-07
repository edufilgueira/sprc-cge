class ChangeUserInputToTickets < ActiveRecord::Migration[5.0]
  def change
    change_column :tickets, :used_input, :integer, null: false, default: Ticket.used_inputs[:system]
  end
end
