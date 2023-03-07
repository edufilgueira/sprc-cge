class RenamePPARegionalInitiativesToPPAAnnualRegionalInitiatives < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_regional_initiatives, :ppa_annual_regional_initiatives
  end
end
