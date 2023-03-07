class AddSubnetIdToServiceTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :service_types, :subnet_id, :integer
  end
end
