class AddChildsCountToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :childs_count, :integer, null: false, default: 0
  end
end
