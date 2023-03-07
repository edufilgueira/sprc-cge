class RemoveSubDepartmentFromTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    remove_index :ticket_departments, :sub_department_id
    remove_column :ticket_departments, :sub_department_id, :integer
  end
end
