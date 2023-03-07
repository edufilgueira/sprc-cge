class ChangeColumnPPAPlanIdOnPPARevisionReviewProblemSituationStrategy < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_review_problem_situation_strategies, :ppa_plan_id, :plan_id
  end
end
