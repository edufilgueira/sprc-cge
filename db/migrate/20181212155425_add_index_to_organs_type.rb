class AddIndexToOrgansType < ActiveRecord::Migration[5.0]
  def change
    add_index :organs, :type
  end
end

