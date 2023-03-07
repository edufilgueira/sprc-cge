class AddIndexesToPPACodes < ActiveRecord::Migration[5.0]
  def change
    # codes
    add_index :ppa_axes,        :code, unique: true
    add_index :ppa_initiatives, :code, unique: true
    add_index :ppa_objectives,  :code, unique: true
    add_index :ppa_products,    :code, unique: true
    add_index :ppa_regions,     :code, unique: true
    add_index :ppa_strategies,  :code, unique: true
    add_index :ppa_themes,      :code, unique: true

    # other unique indexes, including associations
    add_index :ppa_initiative_contributions,
              %i[initiative_id strategy_id],
              unique: true,
              name: 'index_ppa_initiatives_contributions_uniqueness'

    add_index :ppa_regional_strategies,
              %i[strategy_id region_id year],
              unique: true,
              name: 'index_ppa_regional_strategies_uniqueness'

    add_index :ppa_objective_themes,
              %i[objective_id theme_id],
              unique: true,
              name: 'index_ppa_objective_themes_uniqueness'
  end
end
