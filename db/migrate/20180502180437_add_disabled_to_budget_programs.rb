class AddDisabledToBudgetPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :budget_programs, :disabled, :boolean, default: false
  end
end
