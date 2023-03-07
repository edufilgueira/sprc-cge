class RemoveEvaluationToTickets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :evaluation, :integer
  end
end
