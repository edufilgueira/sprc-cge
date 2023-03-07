class AddRatedToSouEvaluationSampleDetails < ActiveRecord::Migration[5.0]
  def change
     add_column :sou_evaluation_sample_details, :rated, :boolean
  end
end
