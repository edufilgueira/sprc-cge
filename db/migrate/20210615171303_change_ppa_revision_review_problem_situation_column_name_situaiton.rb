class ChangePPARevisionReviewProblemSituationColumnNameSituaiton < ActiveRecord::Migration[5.0]
  def up
    rename_column :ppa_revision_review_problem_situations, :ppa_situations_id, :ppa_situation_id
    rename_column :ppa_revision_review_problem_situations, :ppa_revision_review_problem_situation_strategies_id, :ppa_revision_review_problem_situation_strategy_id
  end
  
  def down
    rename_column :ppa_revision_review_problem_situations, :ppa_situation_id, :ppa_situations_id
    rename_column :ppa_revision_review_problem_situations, :ppa_revision_review_problem_situation_strategy_id, :ppa_revision_review_problem_situation_strategies_id
  end
end
