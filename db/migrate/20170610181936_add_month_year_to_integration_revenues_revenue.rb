class AddMonthYearToIntegrationRevenuesRevenue < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_revenues_revenues, :month, :integer
    add_column :integration_revenues_revenues, :year, :integer
  end
end
