class CreateSearchContents < ActiveRecord::Migration[5.0]
  def change
    create_table :search_contents do |t|
      t.string :title
      t.text :content
      t.string :link
      t.timestamps
    end
  end
end
