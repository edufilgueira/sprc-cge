class CreatePPARevisionReviewNewProblemSituation < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_review_new_problem_situations do |t|
      t.text :description
      t.references :theme, index: true, foreign_key: { to_table: :ppa_themes }
      t.references :region, index: true, foreign_key: { to_table: :ppa_regions }
      t.references :city, index: true, foreign_key: { to_table: :cities }
      t.references :problem_situation_strategy, index: { name: 'index_ppa_revision_review_new_problem_situations_on_pss_id'} , foreign_key: { to_table: :ppa_revision_review_problem_situation_strategies }
    end
  end
end
