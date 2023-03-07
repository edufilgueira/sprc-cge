class AddSubnetToDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :departments, :subnet, :boolean
  end
end
