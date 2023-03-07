class AddAppealsToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :appeals, :integer, default: 0
  end
end
