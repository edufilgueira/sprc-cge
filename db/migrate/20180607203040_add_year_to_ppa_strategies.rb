class AddYearToPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies, :year, :integer, null: false
  end
end
