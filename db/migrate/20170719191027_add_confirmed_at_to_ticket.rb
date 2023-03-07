class AddConfirmedAtToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :confirmed_at, :datetime
  end
end
