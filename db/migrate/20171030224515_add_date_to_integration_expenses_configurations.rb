class AddDateToIntegrationExpensesConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_configurations, :started_at, :date
    add_column :integration_expenses_configurations, :finished_at, :date
  end
end
