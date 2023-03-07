class RemoveColumnDetailDescriptionOnPPATheme < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_themes, :detailed_description
  end
end
