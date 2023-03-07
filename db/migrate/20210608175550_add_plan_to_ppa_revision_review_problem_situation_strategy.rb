class AddPlanToPPARevisionReviewProblemSituationStrategy < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_revision_review_problem_situation_strategies, :ppa_plan, foreign_key: true, index: { name: 'index_ppa_r_r_problem_situation_strategies_on_ppa_plan_id' }
    add_reference :ppa_revision_review_problem_situation_strategies, :user, foreign_key: true, index: { name: 'index_ppa_r_r_problem_situation_strategies_on_user_id' }
  end
end
