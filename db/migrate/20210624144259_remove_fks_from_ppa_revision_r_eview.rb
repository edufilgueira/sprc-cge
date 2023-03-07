class RemoveFksFromPPARevisionREview < ActiveRecord::Migration[5.0]
  def change
     
    remove_column :ppa_revision_review_new_problem_situations, :theme_id
    remove_column :ppa_revision_review_new_problem_situations, :region_id

    remove_column :ppa_revision_review_new_regional_strategies, :theme_id
    remove_column :ppa_revision_review_new_regional_strategies, :region_id

  end
end
