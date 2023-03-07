class ChangeDisableableOrgan < ActiveRecord::Migration[5.0]
  def up
    add_column :organs, :disabled_at, :datetime

    execute <<~SQL
      UPDATE organs SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :organs, :disabled, :boolean
  end

  def down
    remove_column :organs, :disabled_at, :datetime
    add_column :organs, :disabled, :boolean, default: false
  end
end
