class CreateImporters < ActiveRecord::Migration[5.0]
  def change
    create_table :importers do |t|
      t.string :name, index: true
      t.references :category, foreign_key: true, null: false
      t.string :response_path, null: false
      t.references :organ, foreign_key: true, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
