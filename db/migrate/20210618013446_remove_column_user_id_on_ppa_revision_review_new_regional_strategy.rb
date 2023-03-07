class RemoveColumnUserIdOnPPARevisionReviewNewRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_revision_review_new_regional_strategies, :user_id
  end
end
