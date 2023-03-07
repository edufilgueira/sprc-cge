class RenamePPARegionalProductsToPPAAnnualRegionalProducts < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_regional_products, :ppa_annual_regional_products
  end
end
