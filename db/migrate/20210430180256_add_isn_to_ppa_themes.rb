class AddIsnToPPAThemes < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_themes, :isn, :integer
    add_index :ppa_themes, :isn, name: 'index_ppa_themes_on_isn'
  end
end
