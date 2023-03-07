class AddCodeToPPARegions < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_regions, :code, :string, null: false
  end
end
