class AddFiltersToSouEvaluationSample < ActiveRecord::Migration[5.0]
  def change
    add_column :sou_evaluation_samples, :filters, :jsonb
  end
end