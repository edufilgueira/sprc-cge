class ChangeSituationToProblemSituation < ActiveRecord::Migration[5.0]
  def change
     remove_column :ppa_revision_review_problem_situations, :situation_id

     add_reference :ppa_revision_review_problem_situations, :problem_situation, index: { name: 'index_ppa_revision_review_problem_situations_problem_situation'}, foreign_key: { to_table: :ppa_problem_situations }
  end
end
