class AddTypeToOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :organs, :type, :string
  end
end

