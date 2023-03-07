class AddDetailedDescriptionToPPAThemes < ActiveRecord::Migration[5.0]
  def change
  	add_column :ppa_themes, :detailed_description, :text
    add_index :ppa_themes, :detailed_description, name: 'index_ppa_themes_on_detailed_description'
  end
end
