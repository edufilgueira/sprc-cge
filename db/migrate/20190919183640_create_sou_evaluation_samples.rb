class CreateSouEvaluationSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :sou_evaluation_samples do |t|
      t.string :code
      t.integer :status
      t.string :name
      t.string :description
      t.integer :organ_id
      t.integer :protocol

      t.timestamps
    end
  end
end