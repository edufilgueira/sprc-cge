class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.string :code
      t.string :name
      t.boolean :disabled, default: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
