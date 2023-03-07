class CreatePPAThemeStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_theme_strategies do |t|
      t.references :theme, index: true, foreign_key: { to_table: 'ppa_themes' }
      t.references :strategy, index: true, foreign_key: { to_table: 'ppa_strategies' }

      t.timestamps
    end
  end
end
