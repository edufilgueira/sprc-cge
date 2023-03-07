class AddPersistToPPARevisionReviewProblemSituation < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_revision_review_problem_situations, :persist, :bit
  end
end
