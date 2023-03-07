class AddAxisIsnToPPAThemes < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_themes, :axis_isn, :integer
    add_index :ppa_themes, :axis_isn, name: 'index_ppa_themes_on_axis_isn'
  end
end
