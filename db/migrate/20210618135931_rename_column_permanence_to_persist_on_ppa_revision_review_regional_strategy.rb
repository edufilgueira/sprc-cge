class RenameColumnPermanenceToPersistOnPPARevisionReviewRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_review_regional_strategies, :permanence, :persist
  end
end
