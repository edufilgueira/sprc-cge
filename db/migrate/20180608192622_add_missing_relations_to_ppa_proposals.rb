class AddMissingRelationsToPPAProposals < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_proposals, :region_id, :integer, index: true, foreign_key: true
    add_column :ppa_proposals, :theme_id, :integer, index: true, foreign_key: true
  end
end
