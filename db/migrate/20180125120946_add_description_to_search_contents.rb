class AddDescriptionToSearchContents < ActiveRecord::Migration[5.0]
  def change
    add_column :search_contents, :description, :text
  end
end
