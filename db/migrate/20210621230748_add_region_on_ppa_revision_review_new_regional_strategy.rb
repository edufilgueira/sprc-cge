class AddRegionOnPPARevisionReviewNewRegionalStrategy < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_revision_review_new_regional_strategies, :region, index: { name: 'index_new_regional_strategies' }, foreign_key: { to_table: 'ppa_regions' }
  end
end
