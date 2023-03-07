class AddDeletedAtToSouEvaluationSamples < ActiveRecord::Migration[5.0]
  def change
    add_column :sou_evaluation_samples, :deleted_at, :datetime
    add_index :sou_evaluation_samples, :deleted_at
  end
end
