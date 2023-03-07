class CreateTablePPARevisionPrioritizationRegionTheme < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_prioritization_region_themes do |t|
      t.references :theme, index: { name: 'index_ppa_revision_priorization_r_t_theme_id'}, foreign_key: { to_table: :ppa_themes }
      t.references :region, index: { name: 'index_ppa_revision_priorization_r_t_region_id'}, foreign_key: { to_table: :ppa_regions }
      t.references :prioritization, index: { name: 'index_ppa_revision_priorization_r_t_prioritization_id'}, foreign_key: { to_table: :ppa_revision_prioritizations }
    end
  end
end
