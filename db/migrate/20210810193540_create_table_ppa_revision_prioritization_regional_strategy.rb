class CreateTablePPARevisionPrioritizationRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_prioritization_regional_strategies do |t|
      t.references :strategy,  index: { name: 'index_ppa_revision_prioritization_rs_on_strategy_id' }, foreign_key: { to_table: :ppa_strategies }
      t.column :priority, :boolean
      t.references :region_theme,  index: { name: 'index_ppa_revision_prioritization_rs_on_region_theme_id' }, foreign_key: { to_table: :ppa_revision_prioritization_region_themes }
      t.timestamps
    end
  end
end
