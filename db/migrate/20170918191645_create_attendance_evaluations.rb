class CreateAttendanceEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_evaluations do |t|
      t.integer :clarity, null: false
      t.integer :content, null: false
      t.integer :wording, null: false
      t.integer :kindness, null: false
      t.float :average
      t.text :comment
      t.references :ticket, foreign_key: true

      t.references :created_by, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
