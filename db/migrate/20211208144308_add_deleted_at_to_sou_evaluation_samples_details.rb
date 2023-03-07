class AddDeletedAtToSouEvaluationSamplesDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :sou_evaluation_sample_details, :deleted_at, :datetime
    add_index :sou_evaluation_sample_details, :deleted_at
  end
end
