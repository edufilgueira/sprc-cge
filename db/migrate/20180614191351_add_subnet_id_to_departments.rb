class AddSubnetIdToDepartments < ActiveRecord::Migration[5.0]
  def change
    remove_column :departments, :subnet, :boolean
    add_column :departments, :subnet_id, :integer
    add_index :departments, :subnet_id
  end
end
