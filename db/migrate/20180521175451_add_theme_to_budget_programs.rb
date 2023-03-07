class AddThemeToBudgetPrograms < ActiveRecord::Migration[5.0]
  def change
    add_reference :budget_programs, :theme, foreign_key: true
  end
end
