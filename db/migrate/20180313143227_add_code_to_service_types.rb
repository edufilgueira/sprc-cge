class AddCodeToServiceTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :service_types, :code, :integer
  end
end
