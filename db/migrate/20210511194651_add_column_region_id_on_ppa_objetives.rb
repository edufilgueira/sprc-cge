class AddColumnRegionIdOnPPAObjetives < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_objectives, :region, index: true, foreign_key: { to_table: 'ppa_regions' }
  end
end
