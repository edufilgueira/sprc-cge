class RemoveCommentToSouEvaluationSampleDetails < ActiveRecord::Migration[5.0]
  def change
    remove_column :sou_evaluation_sample_details, :comment, :string
  end
end
