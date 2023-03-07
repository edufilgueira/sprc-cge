class AddReopenedToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :reopened, :integer, null: false, default: 0
  end
end
