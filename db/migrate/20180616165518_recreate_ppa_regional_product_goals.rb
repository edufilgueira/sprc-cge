class RecreatePPARegionalProductGoals < ActiveRecord::Migration[5.0]
  def change
    rename_index :ppa_annual_regional_product_goals,
                 'index_ppa_regional_product_goals_uniqueness',
                 'index_ppa_annreg_product_goals_uniqueness'

    create_table :ppa_regional_product_goals do |t|
      t.integer :regional_product_id, null: false, index: true
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_foreign_key :ppa_regional_product_goals,
                    :ppa_regional_products,
                    column: :regional_product_id

    add_index :ppa_regional_product_goals,
              %i[regional_product_id],
              unique: true,
              name: 'index_ppa_regional_product_goals_uniqueness'
  end
end
