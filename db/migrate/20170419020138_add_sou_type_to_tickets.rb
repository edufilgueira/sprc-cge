class AddSouTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :sou_type, :integer
    add_index :tickets, :sou_type
  end
end
