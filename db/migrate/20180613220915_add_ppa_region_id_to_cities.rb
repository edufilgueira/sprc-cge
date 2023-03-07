class AddPPARegionIdToCities < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :ppa_region_id, :integer, index: true
  end
end
