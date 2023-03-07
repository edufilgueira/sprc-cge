class AddDisabledToSubDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :sub_departments, :disabled, :boolean, default: false
  end
end
