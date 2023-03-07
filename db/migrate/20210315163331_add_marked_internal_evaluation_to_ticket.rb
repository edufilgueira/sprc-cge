class AddMarkedInternalEvaluationToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :marked_internal_evaluation, :boolean
  end
end
