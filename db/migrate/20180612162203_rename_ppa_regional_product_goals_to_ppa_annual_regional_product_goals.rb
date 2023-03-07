class RenamePPARegionalProductGoalsToPPAAnnualRegionalProductGoals < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_regional_product_goals, :ppa_annual_regional_product_goals
  end
end
