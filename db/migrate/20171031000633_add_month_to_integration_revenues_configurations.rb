class AddMonthToIntegrationRevenuesConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_configurations, :month, :string
  end
end
