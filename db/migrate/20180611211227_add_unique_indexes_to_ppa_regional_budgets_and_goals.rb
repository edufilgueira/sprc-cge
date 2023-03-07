class AddUniqueIndexesToPPARegionalBudgetsAndGoals < ActiveRecord::Migration[5.0]
  def change
    add_index :ppa_regional_initiative_budgets, %i[regional_initiative_id period], unique: true,
      name: 'index_ppa_regional_initiative_budgets_uniqueness'

    add_index :ppa_regional_product_goals, %i[regional_product_id period], unique: true,
      name: 'index_ppa_regional_product_goals_uniqueness'
  end
end
