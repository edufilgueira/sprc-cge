class AddOrganToIntegrationRevenuesRevenues < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_revenues_revenues, :organ, foreign_key: { to_table: :integration_supports_organs })
  end
end
