class AddRegionIdToPPAObjectives < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_objectives, :region_id, :integer, index: true, foreign_key: true
  end
end
