class AddNameToSouEvaluationSamples < ActiveRecord::Migration[5.0]
  def change
  	add_column :sou_evaluation_samples, :name, :string
  end
end
