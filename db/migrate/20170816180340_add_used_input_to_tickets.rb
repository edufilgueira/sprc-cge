class AddUsedInputToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :used_input, :integer
  end
end
