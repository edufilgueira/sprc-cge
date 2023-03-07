class AddIndexObejctiveThemeRegionToPPAObjectiveTheme < ActiveRecord::Migration[5.0]
  def change
    add_index :ppa_objective_themes,
      %i[objective_id theme_id region_id],
      unique: true,
      name: 'index_ppa_objective_themes_region_uniqueness'
  end
end
