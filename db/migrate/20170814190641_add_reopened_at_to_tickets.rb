class AddReopenedAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :reopened_at, :date
  end
end
