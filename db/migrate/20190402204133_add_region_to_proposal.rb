class AddRegionToProposal < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_proposals, :region_id, :integer, :null => false
  	add_foreign_key :ppa_proposals, :ppa_regions, column: :region_id
  end
end
