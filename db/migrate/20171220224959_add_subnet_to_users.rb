class AddSubnetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subnet, :boolean
  end
end
