class AddOrgansToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_contracts_contracts, :manager, foreign_key: { to_table: :integration_supports_organs })
    add_reference(:integration_contracts_contracts, :grantor, foreign_key: { to_table: :integration_supports_organs })
  end
end
