class RemoveSubnetFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :subnet, :boolean
  end
end
