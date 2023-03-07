class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.integer :code, null: false
      t.string :acronym, null: false
      t.string :name, null: false
    end
  end
end
