class CreateHolidays < ActiveRecord::Migration[5.0]
  def change
    create_table :holidays do |t|
      t.string :title
      t.integer :day
      t.integer :month
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :holidays, [:day, :month]
  end
end
