class ChangeTicketReopenedAtToDatetime < ActiveRecord::Migration[5.0]
  def change
    change_column :tickets, :reopened_at, :datetime
  end
end
