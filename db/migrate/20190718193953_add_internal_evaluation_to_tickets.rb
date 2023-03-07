class AddInternalEvaluationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :internal_evaluation, :boolean
  end
end
