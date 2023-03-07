class EnhancePPAProposals < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_proposals, :votings_count, :votes_count

    remove_column :ppa_proposals, :region_id, :integer
    change_column_null :ppa_proposals, :objective_id, true
    change_column_null :ppa_proposals, :theme_id,     false
    change_column_null :ppa_proposals, :user_id,      false

    add_column :ppa_proposals, :city_id, :integer, index: true, null: false
    add_foreign_key :ppa_proposals, :cities, column: :city_id
  end
end
