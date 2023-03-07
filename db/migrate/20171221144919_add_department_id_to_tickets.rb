class AddDepartmentIdToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :department_id, :integer
    add_index :tickets, :department_id
  end
end
