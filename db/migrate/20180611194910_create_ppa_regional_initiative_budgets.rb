class CreatePPARegionalInitiativeBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regional_initiative_budgets do |t|
      t.integer :regional_initiative_id, null: false, index: true
      t.integer :period
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_foreign_key :ppa_regional_initiative_budgets,
                    :ppa_regional_initiatives,
                    column: :regional_initiative_id
  end
end
