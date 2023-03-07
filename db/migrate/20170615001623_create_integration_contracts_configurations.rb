class CreateIntegrationContractsConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_configurations do |t|
      t.string :endpoint
      t.string :wsdl
      t.string :user
      t.string :password
      t.string :contract_operation
      t.string :contract_response_path
      t.string :contract_parameters
      t.string :additive_operation
      t.string :additive_response_path
      t.string :additive_parameters
      t.string :adjustment_operation
      t.string :adjustment_response_path
      t.string :adjustment_parameters
      t.string :financial_operation
      t.string :financial_response_path
      t.string :financial_parameters
      t.string :infringement_operation
      t.string :infringement_response_path
      t.string :infringement_parameters
      t.integer :status
      t.datetime :last_importation
      t.text :log

      t.timestamps
    end
  end
end
