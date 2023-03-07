class CreateBudgetPrograms < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_programs do |t|
      t.string :name, index: true
      t.string :code
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
