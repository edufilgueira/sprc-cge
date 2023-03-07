class CreatePPABiennialRegionalProductGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_biennial_regional_product_goals do |t|
      t.integer :regional_product_id, null: false #, index: true => name too long! see below
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_index :ppa_biennial_regional_product_goals,
              :regional_product_id,
              name: 'index_ppa_biennreg_product_goals_on_regional_product_id',
              unique: true
    add_foreign_key :ppa_biennial_regional_product_goals,
                    :ppa_biennial_regional_products,
                    column: :regional_product_id

    remove_index :ppa_biennial_regional_initiative_budgets,
                 name: 'index_ppa_biennreg_initiative_budgets_on_regional_initiative_id'

    add_index :ppa_biennial_regional_initiative_budgets,
              :regional_initiative_id,
              name: 'index_ppa_biennreg_initiative_budgets_on_regional_initiative_id',
              unique: true

  end
end
