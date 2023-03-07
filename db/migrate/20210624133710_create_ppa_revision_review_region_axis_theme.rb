class CreatePPARevisionReviewRegionAxisTheme < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_region_axis_themes do |t|
      t.references :axis, index: true, foreign_key: { to_table: :ppa_axes }
      t.references :theme, index: true, foreign_key: { to_table: :ppa_themes }
      t.references :region, index: true, foreign_key: { to_table: :ppa_regions }
      t.references :problem_situation_strategy, index: { name: 'index_ppa_r_r_axis_theme_regions_on_p_s_s_id'}, foreign_key: { to_table: :ppa_revision_review_problem_situation_strategies }
    end
  end
end
