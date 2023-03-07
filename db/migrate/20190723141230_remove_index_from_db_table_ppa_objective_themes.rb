class RemoveIndexFromDbTablePPAObjectiveThemes < ActiveRecord::Migration[5.0]
  def change
    remove_index "ppa_objective_themes", name: "index_ppa_objective_themes_on_objective_id_and_theme_id"
    remove_index "ppa_objective_themes", name: "index_ppa_objective_themes_uniqueness"
  end
end
