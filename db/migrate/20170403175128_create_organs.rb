class CreateOrgans < ActiveRecord::Migration[5.0]
  def change
    create_table :organs do |t|
      t.string :acronym
      t.string :name
      t.text :description
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
