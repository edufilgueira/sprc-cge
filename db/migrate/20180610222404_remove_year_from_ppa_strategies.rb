class RemoveYearFromPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_strategies, :year, :integer
  end
end
