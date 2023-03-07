class AddDisabledToDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :departments, :disabled, :boolean, default: false
  end
end
