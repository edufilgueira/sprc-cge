class CreateOccurrences < ActiveRecord::Migration[5.0]
  def change
    create_table :occurrences do |t|
      t.text :description
      t.references :attendance, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
