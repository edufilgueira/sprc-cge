class RecreatePPARegionalInitiativeBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_regional_initiative_budgets do |t|
      t.integer :regional_initiative_id, null: false, index: true
      t.decimal :expected, precision: 15, scale: 2 # trillions
      t.decimal :actual,   precision: 15, scale: 2 # trillions

      t.timestamps
    end

    add_foreign_key :ppa_regional_initiative_budgets,
                    :ppa_regional_initiatives,
                    column: :regional_initiative_id

    add_index :ppa_regional_initiative_budgets,
              %i[regional_initiative_id],
              unique: true,
              name: 'index_ppa_regional_initiative_budgets_uniqueness'
  end
end
