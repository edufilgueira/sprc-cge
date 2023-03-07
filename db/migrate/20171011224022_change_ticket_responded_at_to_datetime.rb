class ChangeTicketRespondedAtToDatetime < ActiveRecord::Migration[5.0]
  def change
    change_column :tickets, :responded_at, :datetime
  end
end
