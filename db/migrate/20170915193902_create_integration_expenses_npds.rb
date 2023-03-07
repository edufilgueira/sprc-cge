class CreateIntegrationExpensesNpds < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_npds do |t|
      t.string :exercicio
      t.string :unidade_gestora
      t.string :unidade_executora
      t.string :numero
      t.string :numero_npd_ordinaria
      t.string :codigo_localidade_npd_ordinaria
      t.string :codigo_retencao
      t.string :natureza
      t.string :justificativa
      t.string :efeito
      t.string :numero_processo_administrativo_despesa
      t.string :data_emissao
      t.string :credor
      t.string :documento_credor
      t.decimal :valor
      t.string :numero_nld_ordinaria
      t.string :codigo_natureza_receita
      t.string :servico_bancario
      t.string :banco_origem
      t.string :agencia_origem
      t.string :digito_agencia_origem
      t.string :conta_origem
      t.string :digito_conta_origem
      t.string :banco_pagamento
      t.string :codigo_localidade
      t.string :banco_beneficiario
      t.string :agencia_beneficiario
      t.string :digito_agencia_beneficiario
      t.string :conta_beneficiario
      t.string :digito_conta_beneficiario
      t.string :status_movimento_bancario
      t.string :data_retorno_remessa_bancaria
      t.string :processo_judicial
      t.string :data_atual

      t.integer :integration_expenses_nld_id

      t.timestamps
    end

    add_index :integration_expenses_npds, [:exercicio, :unidade_gestora, :numero], unique: true, name: "index_exercicio_unidade_gestora_numero_on_npds"
    add_index :integration_expenses_npds, :integration_expenses_nld_id, name: "index_expenses_nlds_on_integration_expenses_nld_id"
  end
end
