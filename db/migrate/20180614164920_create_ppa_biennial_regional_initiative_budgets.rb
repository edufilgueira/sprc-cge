class CreatePPABiennialRegionalInitiativeBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_biennial_regional_initiative_budgets do |t|
      t.integer :regional_initiative_id, null: false #, index: true => name too long! see below
      t.integer :period
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_index :ppa_biennial_regional_initiative_budgets,
              :regional_initiative_id,
              name: 'index_ppa_biennreg_initiative_budgets_on_regional_initiative_id'
    add_foreign_key :ppa_biennial_regional_initiative_budgets,
                    :ppa_biennial_regional_initiatives,
                    column: :regional_initiative_id
  end
end
