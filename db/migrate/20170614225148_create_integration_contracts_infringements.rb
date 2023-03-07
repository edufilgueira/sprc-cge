class CreateIntegrationContractsInfringements < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_infringements do |t|
      t.string :cod_financiador
      t.string :cod_gestora
      t.string :descricao_entidade
      t.string :descricao_financiador
      t.string :descricao_motivo_inadimplencia
      t.datetime :data_lancamento
      t.datetime :data_processamento
      t.datetime :data_termino_atual
      t.datetime :data_ultima_pcontas
      t.datetime :data_ultima_pagto
      t.integer :isn_sic
      t.integer :qtd_pagtos
      t.decimal :valor_atualizado_total
      t.decimal :valor_inadimplencia
      t.decimal :valor_liberacoes
      t.decimal :valor_pcontas_acomprovar
      t.decimal :valor_pcontas_apresentada
      t.decimal :valor_pcontas_aprovada
      t.integer :integration_contracts_contract_id

      t.timestamps
    end

    add_index :integration_contracts_infringements, :integration_contracts_contract_id, name: "index_contracts_infringements_on_revenue_id"
  end
end
