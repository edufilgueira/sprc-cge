class RemovePPASourceThemes < ActiveRecord::Migration[5.0]
  def change
    # movido para sprc-data @ PPA::Source::AxisTheme
    drop_table :ppa_source_themes
  end
end
