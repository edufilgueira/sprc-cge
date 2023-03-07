class AddCreatedByIdToSouEvaluationSample < ActiveRecord::Migration[5.0]
  def change
    add_column :sou_evaluation_samples, :created_by_id, :integer
  end
end
