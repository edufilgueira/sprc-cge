class AddSubDepartmentIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :sub_department_id, :integer
    add_index :users, :sub_department_id

    add_index :users, :secondary
    add_index :users, :operator_type
  end
end
