class AddSubnetToOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :organs, :subnet, :boolean
    add_index :organs, :subnet
    add_index :organs, :acronym
    add_index :organs, :code
  end
end
