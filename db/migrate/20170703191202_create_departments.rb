class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.string :name, index: true
      t.references :organ, foreign_key: true
      t.string :acronym
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
