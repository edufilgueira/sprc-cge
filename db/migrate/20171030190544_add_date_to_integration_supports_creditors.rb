class AddDateToIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_creditor_configurations, :started_at, :date
    add_column :integration_supports_creditor_configurations, :finished_at, :date
  end
end
