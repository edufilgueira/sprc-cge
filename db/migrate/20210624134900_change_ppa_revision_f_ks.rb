class ChangePPARevisionFKs < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_revision_review_new_problem_situations, :problem_situation_strategy_id
    remove_column :ppa_revision_review_problem_situations, :problem_situation_strategy_id
    remove_column :ppa_revision_review_regional_strategies, :problem_situation_strategy_id
    remove_column :ppa_revision_review_new_regional_strategies, :problem_situation_strategy_id

    add_reference :ppa_revision_review_new_problem_situations, :region_axis_theme, foreign_key: { to_table: 'ppa_revision_review_region_axis_themes' }, index: { name: 'index_ppa_r_r_new_problem_situations_region_axis_themes' }
    add_reference :ppa_revision_review_problem_situations, :region_axis_theme, foreign_key: { to_table: 'ppa_revision_review_region_axis_themes' }, index: { name: 'index_ppa_r_r_problem_situations_region_axis_themes' }
    add_reference :ppa_revision_review_new_regional_strategies, :region_axis_theme, foreign_key: { to_table: 'ppa_revision_review_region_axis_themes' }, index: { name: 'index_ppa_r_r_new_regional_strategies_region_axis_themes' }
    add_reference :ppa_revision_review_regional_strategies, :region_axis_theme, foreign_key: { to_table: 'ppa_revision_review_region_axis_themes' }, index: { name: 'index_ppa_r_r_regional_strategies_region_axis_themes' }
    
  end
end
