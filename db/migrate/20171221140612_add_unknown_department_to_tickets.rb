class AddUnknownDepartmentToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :unknown_department, :boolean
    add_index :tickets, :unknown_department
  end
end
