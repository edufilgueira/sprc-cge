class AddOrganToTickets < ActiveRecord::Migration[5.0]
  def change
    add_reference :tickets, :organ, foreign_key: true
  end
end
