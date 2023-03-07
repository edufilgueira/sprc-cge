class AddSubDepartmentIdToTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_departments, :sub_department_id, :integer
    add_index :ticket_departments, :sub_department_id
  end
end
