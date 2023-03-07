class RemoveSubDepartmentFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :sub_department_id
    remove_column :users, :sub_department_id, :integer
  end
end
