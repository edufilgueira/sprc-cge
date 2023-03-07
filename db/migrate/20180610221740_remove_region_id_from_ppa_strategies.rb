class RemoveRegionIdFromPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_strategies, :region_id, :integer
  end
end
