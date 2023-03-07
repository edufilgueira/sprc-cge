class AddInitiativesCountAndProductsCountToPPABiennialRegionalStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_biennial_regional_strategies, :initiatives_count, :integer, index: true
    add_column :ppa_biennial_regional_strategies, :products_count,    :integer, index: true
  end
end
