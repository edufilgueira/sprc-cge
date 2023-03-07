class RenamePPARegionalStrategiesToPPAAnnualRegionalStrategies < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_regional_strategies, :ppa_annual_regional_strategies
  end
end
