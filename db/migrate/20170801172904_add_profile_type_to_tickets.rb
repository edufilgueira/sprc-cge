class AddProfileTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :person_type, :integer, default: 0
  end
end
