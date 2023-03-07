class RemoveColumnAxisIsnOnPPAThemes < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_themes, :axis_isn
  end
end
