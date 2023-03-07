class ChangeDisableableUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :disabled_at, :datetime

    execute <<~SQL
      UPDATE users SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :users, :disabled, :boolean
  end

  def down
    remove_column :users, :disabled_at, :datetime
    add_column :users, :disabled, :boolean, default: false
  end
end
