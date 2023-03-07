class AddEvaluationSamplesToTickets < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :evaluation_samples, :boolean
  end
end
