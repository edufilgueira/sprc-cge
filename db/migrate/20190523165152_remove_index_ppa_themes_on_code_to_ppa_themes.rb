class RemoveIndexPPAThemesOnCodeToPPAThemes < ActiveRecord::Migration[5.0]
   def change
    remove_index 'ppa_themes', name: 'index_ppa_themes_on_code'
  end
end
