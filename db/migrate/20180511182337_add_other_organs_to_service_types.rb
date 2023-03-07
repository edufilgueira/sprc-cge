class AddOtherOrgansToServiceTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :service_types, :other_organs, :boolean, default: false
  end
end
