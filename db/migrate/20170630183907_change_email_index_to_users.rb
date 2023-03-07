class ChangeEmailIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    add_index :users, [:email, :deleted_at], unique: true
  end
end
