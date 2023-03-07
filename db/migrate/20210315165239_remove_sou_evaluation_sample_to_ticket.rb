class RemoveSouEvaluationSampleToTicket < ActiveRecord::Migration[5.0]
  def change
  	remove_column :tickets, :sou_evaluation_sample, :boolean
  end
end
