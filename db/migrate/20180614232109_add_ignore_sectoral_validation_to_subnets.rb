class AddIgnoreSectoralValidationToSubnets < ActiveRecord::Migration[5.0]
  def change
    add_column :subnets, :ignore_sectoral_validation, :boolean
  end
end
