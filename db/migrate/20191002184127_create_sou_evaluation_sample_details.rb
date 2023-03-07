class CreateSouEvaluationSampleDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :sou_evaluation_sample_details do |t|
      t.references :sou_evaluation_sample, foreign_key: true
      t.references :ticket, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
