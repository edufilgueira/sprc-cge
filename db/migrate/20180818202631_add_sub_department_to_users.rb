class AddSubDepartmentToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :sub_department, foreign_key: true
  end
end
