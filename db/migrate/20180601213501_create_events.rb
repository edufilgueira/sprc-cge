class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :starts_at
      t.string :category
      t.text :description

      t.timestamps
    end
  end
end
