class RemoveSecondaryToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :secondary, :boolean
  end
end
