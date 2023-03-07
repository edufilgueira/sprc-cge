class AddOtherOrgansToBudgetPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :budget_programs, :other_organs, :boolean, default: false
  end
end
