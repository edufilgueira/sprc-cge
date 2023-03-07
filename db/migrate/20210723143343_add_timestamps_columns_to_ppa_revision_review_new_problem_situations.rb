class AddTimestampsColumnsToPPARevisionReviewNewProblemSituations < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :ppa_revision_review_new_problem_situations, null: false, default: -> { 'NOW()' }
  end
end
