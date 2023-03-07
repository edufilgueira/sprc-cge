class CreatePPARevisionReviewProblemSituationStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_problem_situation_strategies do |t|
    	t.timestamps
    end
  end
end
