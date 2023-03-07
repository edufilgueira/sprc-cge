class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.integer :code, null: false
      t.string :name, null: false
      t.references :state, foreign_key: true, null: false
    end
  end
end
