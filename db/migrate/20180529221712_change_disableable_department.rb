class ChangeDisableableDepartment < ActiveRecord::Migration[5.0]
  def up
    add_column :departments, :disabled_at, :datetime

    execute <<~SQL
      UPDATE departments SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :departments, :disabled, :boolean
  end

  def down
    remove_column :departments, :disabled_at, :datetime
    add_column :departments, :disabled, :boolean, default: false
  end
end
