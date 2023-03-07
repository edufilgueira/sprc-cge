class RemoveRegionIdFromPPAObjectives < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_objectives, :region_id, :integer
  end
end
