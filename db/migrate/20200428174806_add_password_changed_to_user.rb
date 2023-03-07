class AddPasswordChangedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_changed_at, :datetime
  end
end
