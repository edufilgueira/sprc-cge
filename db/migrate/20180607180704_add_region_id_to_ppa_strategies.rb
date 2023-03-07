class AddRegionIdToPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies, :region_id, :integer, null: false, index: true
  end
end
