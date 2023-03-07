class AddTimestampsColumnsToPPARevisionReviewRegionTheme < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:ppa_revision_review_region_themes)
  end
end
