class AddAppealsAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :appeals_at, :datetime
  end
end
