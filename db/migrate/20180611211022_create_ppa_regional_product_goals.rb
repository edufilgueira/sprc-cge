class CreatePPARegionalProductGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regional_product_goals do |t|
      t.integer :regional_product_id, null: false, index: true
      t.integer :period
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_foreign_key :ppa_regional_product_goals,
                    :ppa_regional_products,
                    column: :regional_product_id
  end
end
