class RemoveEvaluationSamplesToTickets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :evaluation_samples, :boolean
  end
end