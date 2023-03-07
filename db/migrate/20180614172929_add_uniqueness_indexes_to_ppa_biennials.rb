class AddUniquenessIndexesToPPABiennials < ActiveRecord::Migration[5.0]
  def change
    add_index :ppa_biennial_regional_strategies,
              %i[strategy_id region_id start_year], # end_year is not necessary for bienniums
              unique: true,
              name: 'index_ppa_biennreg_strategies_uniqueness'

    add_index :ppa_biennial_regional_initiatives,
              %i[initiative_id region_id start_year],  # end_year is not necessary for bienniums
              unique: true,
              name: 'index_ppa_biennreg_initiatives_uniqueness'

    add_index :ppa_biennial_regional_products,
              %i[product_id region_id start_year],  # end_year is not necessary for bienniums
              unique: true,
              name: 'index_ppa_biennreg_products_uniqueness'

    add_index :ppa_biennial_regional_initiative_budgets,
              %i[regional_initiative_id period],
              unique: true,
              name: 'index_ppa_biennreg_initiative_budgets_uniqueness'

    # XXX associação não necessária ao PPA por ora
    # add_index :ppa_biennial_regional_product_goals,
    #           %i[regional_product_id period],
    #           unique: true,
    #           name: 'index_ppa_biennreg_product_goals_uniqueness'
  end
end
