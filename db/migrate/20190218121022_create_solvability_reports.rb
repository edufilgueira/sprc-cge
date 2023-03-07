class CreateSolvabilityReports < ActiveRecord::Migration[5.0]
  def change
    create_table :solvability_reports do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.integer :status
      t.text :filters
      t.string :filename
      t.integer :processed
      t.integer :total
      t.integer :total_to_process

      t.timestamps
    end
  end
end
