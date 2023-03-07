class AddDecrementDeadlineToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :decrement_deadline, :boolean
  end
end
