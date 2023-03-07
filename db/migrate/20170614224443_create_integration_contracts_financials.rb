class CreateIntegrationContractsFinancials < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_financials do |t|
      t.string :ano_documento
      t.integer :cod_entidade
      t.integer :cod_fonte
      t.integer :cod_gestor
      t.string :descricao_entidade
      t.string :descricao_objeto
      t.datetime :data_documento
      t.datetime :data_pagamento
      t.datetime :data_processamento
      t.integer :flg_sic
      t.integer :isn_sic
      t.string :num_pagamento
      t.string :num_documento
      t.decimal :valor_documento
      t.decimal :valor_pagamento
      t.string :cod_credor
      t.integer :integration_contracts_contract_id

      t.timestamps
    end

    add_index :integration_contracts_financials, :integration_contracts_contract_id, name: "index_contracts_financials_on_revenue_id"
  end
end
