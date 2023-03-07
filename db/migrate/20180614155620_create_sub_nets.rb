class CreateSubNets < ActiveRecord::Migration[5.0]
  def change
    create_table :subnets do |t|
      t.string :name
      t.references :organ, foreign_key: true
      t.string :acronym
      t.datetime :deleted_at, index: true
      t.datetime :disabled_at, index: true

      t.timestamps
    end
  end
end
