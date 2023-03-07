class RemoveAxisFromPPARevisionRat < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_revision_review_region_axis_themes, :axis_id

    rename_table :ppa_revision_review_region_axis_themes, :ppa_revision_review_region_themes
  end
end
