class AddRegionToObjectiveThemes < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_objective_themes, :region_id, :integer
    add_foreign_key :ppa_objective_themes, :ppa_regions, column: :region_id
  end
end
