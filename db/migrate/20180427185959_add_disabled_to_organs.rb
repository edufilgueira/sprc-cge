class AddDisabledToOrgans < ActiveRecord::Migration[5.0]
  def change
    add_column :organs, :disabled, :boolean, default: false
  end
end
