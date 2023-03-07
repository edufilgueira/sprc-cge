class AddDeadlineEndsAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :deadline_ends_at, :date
  end
end
