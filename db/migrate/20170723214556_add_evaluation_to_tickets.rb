class AddEvaluationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :evaluation, :integer, in: 0..10
  end
end
