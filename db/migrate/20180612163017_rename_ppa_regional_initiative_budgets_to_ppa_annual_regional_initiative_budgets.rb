class RenamePPARegionalInitiativeBudgetsToPPAAnnualRegionalInitiativeBudgets < ActiveRecord::Migration[5.0]
  def change
    # t.index ["regional_initiative_id", "period"], name: "index_ppa_regional_initiative_budgets_uniqueness", unique: true, using: :btree
    # t.index ["regional_initiative_id"], name: "index_ppa_regional_initiative_budgets_on_regional_initiative_id", using: :btree

    rename_index :ppa_regional_initiative_budgets,
                 'index_ppa_regional_initiative_budgets_uniqueness',
                 'index_ppa_annreg_initiative_budgets_uniqueness'

    rename_index :ppa_regional_initiative_budgets,
                 'index_ppa_regional_initiative_budgets_on_regional_initiative_id',
                 'index_ppa_annreg_initiative_budgets_on_regional_initiative_id'

    rename_table :ppa_regional_initiative_budgets, :ppa_annual_regional_initiative_budgets
  end
end
