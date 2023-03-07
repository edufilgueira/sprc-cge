class ChangeFkNamesInPPARevision < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_review_new_problem_situations, :region_axis_theme_id, :region_theme_id
    rename_column :ppa_revision_review_new_regional_strategies, :region_axis_theme_id, :region_theme_id
    rename_column :ppa_revision_review_problem_situations, :region_axis_theme_id, :region_theme_id
    rename_column :ppa_revision_review_regional_strategies, :region_axis_theme_id, :region_theme_id
  end
end
