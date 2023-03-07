class CreateEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :evaluations do |t|
      t.integer :question_01_a
      t.integer :question_01_b
      t.integer :question_01_c
      t.integer :question_01_d
      t.integer :question_02
      t.integer :question_03
      t.string :question_04
      t.float :average
      t.references :answer, foreign_key: true
      t.integer :evaluation_type

      t.timestamps
    end
  end
end
