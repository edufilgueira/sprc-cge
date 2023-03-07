class CreateEvaluationExports < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluation_exports do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :user, foreign_key: true
      t.references :organ, foreign_key: true
      t.references :subnet, foreign_key: true
      t.text :filters
      t.integer :status
      t.integer :processed
      t.integer :total_to_process

      t.timestamps
    end
  end
end
