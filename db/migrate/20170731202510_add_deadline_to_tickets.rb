class AddDeadlineToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :deadline, :integer
  end
end
