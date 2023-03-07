class ChangeColumnsOnPPARevisionReviewProblemSituation < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_review_problem_situations, :ppa_situation_id, :situation_id
    rename_column :ppa_revision_review_problem_situations, :ppa_revision_review_problem_situation_strategy_id, :problem_situation_strategy_id
  end
end
