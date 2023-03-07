class AddCodeToOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :organs, :code, :string
  end
end
