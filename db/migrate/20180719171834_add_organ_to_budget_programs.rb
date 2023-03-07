class AddOrganToBudgetPrograms < ActiveRecord::Migration[5.0]
  def change
    add_reference :budget_programs, :organ, foreign_key: true, index: true
    add_reference :budget_programs, :subnet, foreign_key: true, index: true
  end
end
