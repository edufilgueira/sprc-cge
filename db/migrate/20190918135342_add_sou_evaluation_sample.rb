class AddSouEvaluationSample < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :sou_evaluation_sample, :boolean
  end
end