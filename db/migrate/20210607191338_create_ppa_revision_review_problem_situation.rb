class CreatePPARevisionReviewProblemSituation < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_problem_situations do |t|
      
      t.references :ppa_revision_review_problem_situation_strategies, foreign_key: true, null: false, index: { name: 'index_ppa_revision_review_problem_situation_strategies_id' }
      t.references :ppa_situations, foreign_key: true, null: false, index: { name: 'index_ppa_revision_review_pss_ppa_situations_id' }
      t.timestamps
    end
  end
end
