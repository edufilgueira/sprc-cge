class CreateClassifications < ActiveRecord::Migration[5.0]
  def change
    create_table :classifications do |t|
      t.references :ticket, foreign_key: true
      t.references :topic, foreign_key: true
      t.references :subtopic, foreign_key: true
      t.references :department, foreign_key: true
      t.references :sub_department, foreign_key: true
      t.references :budget_program, foreign_key: true
      t.references :service_type, foreign_key: true

      t.timestamps
    end
  end
end
