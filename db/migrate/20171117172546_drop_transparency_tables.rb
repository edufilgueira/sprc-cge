class DropTransparencyTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :integration_contracts_additives
    drop_table :integration_contracts_adjustments
    drop_table :integration_contracts_configurations
    drop_table :integration_contracts_contracts
    drop_table :integration_contracts_financials
    drop_table :integration_contracts_infringements
    drop_table :integration_expenses_configurations
    drop_table :integration_expenses_ned_disbursement_forecasts
    drop_table :integration_expenses_ned_items
    drop_table :integration_expenses_ned_planning_items
    drop_table :integration_expenses_neds
    drop_table :integration_expenses_nld_item_payment_plannings
    drop_table :integration_expenses_nld_item_payment_retentions
    drop_table :integration_expenses_nlds
    drop_table :integration_expenses_npds
    drop_table :integration_expenses_npfs
    drop_table :integration_revenues_account_configurations
    drop_table :integration_revenues_accounts
    drop_table :integration_revenues_configurations
    drop_table :integration_revenues_revenues
    drop_table :integration_servers_configurations
    drop_table :integration_servers_proceed_types
    drop_table :integration_servers_proceeds
    drop_table :integration_servers_registrations
    drop_table :integration_servers_server_expenses
    drop_table :integration_servers_servers
    drop_table :integration_supports_creditor_configurations
    drop_table :integration_supports_creditors
    drop_table :integration_supports_organ_configurations
    drop_table :integration_supports_organs


    drop_table :open_data
    drop_table :importers
    drop_table :schedules
    drop_table :categories
  end
end
