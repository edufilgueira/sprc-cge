class ChangeDisableableBudgetProgram < ActiveRecord::Migration[5.0]
  def up
    add_column :budget_programs, :disabled_at, :datetime

    execute <<~SQL
      UPDATE budget_programs SET disabled_at = updated_at WHERE disabled = true
    SQL

    remove_column :budget_programs, :disabled, :boolean
  end

  def down
    remove_column :budget_programs, :disabled_at, :datetime
    add_column :budget_programs, :disabled, :boolean, default: false
  end
end
