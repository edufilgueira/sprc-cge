class CreateSubDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_departments do |t|
      t.string :name, index: true
      t.references :department, foreign_key: true
      t.string :acronym
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
