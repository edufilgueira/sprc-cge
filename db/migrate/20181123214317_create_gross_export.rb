class CreateGrossExport < ActiveRecord::Migration[5.0]
  def change
    create_table :gross_exports do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :filters
      t.integer :status
      t.string :filename
      t.integer :processed
      t.integer :total
      t.integer :total_to_process

      t.timestamps
    end
  end
end
