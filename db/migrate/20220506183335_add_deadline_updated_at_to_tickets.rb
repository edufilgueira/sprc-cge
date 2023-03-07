class AddDeadlineUpdatedAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :deadline_updated_at, :datetime
  end
end
