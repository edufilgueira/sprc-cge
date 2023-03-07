class AddSecondaryToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :secondary, :boolean
  end
end
