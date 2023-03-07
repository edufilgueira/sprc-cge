class AddCreditorsToIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    add_reference(:integration_contracts_contracts, :creditor, foreign_key: { to_table: :integration_supports_creditors })
  end
end
