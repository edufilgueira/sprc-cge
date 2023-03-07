class AddRespondedAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :responded_at, :date
  end
end
