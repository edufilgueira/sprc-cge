class AddPPAObjectiveThemeToPPAStrategy < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies, :objective_theme_id, :integer
    add_foreign_key :ppa_strategies, :ppa_objective_themes, column: :objective_theme_id
  end
end
