class CreatePPAObjectiveThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_objective_themes do |t|
      t.integer :objective_id, null: false
      t.integer :theme_id,     null: false

      t.timestamps
    end
    add_index :ppa_objective_themes, [:objective_id, :theme_id], unique: true
  end
end
