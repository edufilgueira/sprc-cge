class ChangeDisableableTheme < ActiveRecord::Migration[5.0]
  def up
    add_column :themes, :disabled_at, :datetime

    execute <<~SQL
      UPDATE themes SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :themes, :disabled, :boolean
  end

  def down
    remove_column :themes, :disabled_at, :datetime
    add_column :themes, :disabled, :boolean, default: false
  end
end
