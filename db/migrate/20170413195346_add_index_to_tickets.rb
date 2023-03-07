class AddIndexToTickets < ActiveRecord::Migration[5.0]
  def change
    add_index :tickets, :status
  end
end
