class RemoveUnusedAttrsAndModelsFromPPAModels < ActiveRecord::Migration[5.0]
  def change
    drop_table :ppa_metrics

    remove_column :ppa_strategies, :initiatives_count, :integer
    remove_column :ppa_strategies, :products_count,    :integer

    remove_column :ppa_annual_regional_strategies, :priority, :integer

    remove_column :ppa_biennial_regional_initiative_budgets, :period,         :integer
    remove_column :ppa_biennial_regional_initiatives,        :products_count, :integer
  end
end
