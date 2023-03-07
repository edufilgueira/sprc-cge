class ChangePersistBooleanInPPARevisionReviewProblemSituationStrategy < ActiveRecord::Migration[5.0]
  def up
    remove_column :ppa_revision_review_problem_situations,  :persist
    add_column :ppa_revision_review_problem_situations, :persist, :boolean
  end

  def down
    remove_column :ppa_revision_review_problem_situations,  :persist
    add_column :ppa_revision_review_problem_situations, :persist, :bit
  end
end
