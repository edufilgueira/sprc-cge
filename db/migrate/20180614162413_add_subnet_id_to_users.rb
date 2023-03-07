class AddSubnetIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subnet_id, :integer
    add_index :users, :subnet_id
  end
end
