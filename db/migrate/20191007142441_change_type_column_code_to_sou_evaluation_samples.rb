class ChangeTypeColumnCodeToSouEvaluationSamples < ActiveRecord::Migration[5.0]
  def change
    change_column :sou_evaluation_samples, :code, 'integer USING CAST(code AS integer)'
  end
end