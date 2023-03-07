class RenameNameToSouEvaluationSample < ActiveRecord::Migration[5.0]
  def up
    rename_column :sou_evaluation_samples, :name, :title
  end

  def down
    rename_column :sou_evaluation_samples, :title, :name
  end
end
