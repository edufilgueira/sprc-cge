class ChangeDisableableSubdepartment < ActiveRecord::Migration[5.0]
  def up
    add_column :sub_departments, :disabled_at, :datetime

    execute <<~SQL
      UPDATE sub_departments SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :sub_departments, :disabled, :boolean
  end

  def down
    remove_column :sub_departments, :disabled_at, :datetime
    add_column :sub_departments, :disabled, :boolean, default: false
  end
end
