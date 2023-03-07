class ChangeDisableableServiceType < ActiveRecord::Migration[5.0]
  def up
    add_column :service_types, :disabled_at, :datetime

    execute <<~SQL
      UPDATE service_types SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :service_types, :disabled, :boolean
  end

  def down
    remove_column :service_types, :disabled_at, :datetime
    add_column :service_types, :disabled, :boolean, default: false
  end
end
