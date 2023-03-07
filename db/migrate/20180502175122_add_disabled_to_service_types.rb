class AddDisabledToServiceTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :service_types, :disabled, :boolean, default: false
  end
end
