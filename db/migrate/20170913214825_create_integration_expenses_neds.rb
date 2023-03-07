class CreateIntegrationExpensesNeds < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_neds do |t|
      t.integer :exercicio
      t.string  :unidade_gestora
      t.string  :unidade_executora
      t.string  :numero
      t.string  :numero_ned_ordinaria
      t.string  :natureza
      t.string  :efeito
      t.string  :data_emissao
      t.decimal :valor
      t.decimal :valor_pago
      t.integer :classificacao_orcamentaria_reduzido
      t.string  :classificacao_orcamentaria_completo
      t.string  :item_despesa
      t.string  :cpf_ordenador_despesa
      t.string  :credor
      t.string  :cpf_cnpj_credor
      t.string  :razao_social_credor
      t.string  :numero_npf_ordinario
      t.string  :projeto
      t.string  :numero_parcela
      t.integer :isn_parcela
      t.string  :numero_contrato
      t.string  :numero_convenio
      t.string  :modalidade_sem_licitacao
      t.string  :codigo_dispositivo_legal
      t.string  :modalidade_licitacao
      t.integer :tipo_proposta
      t.integer :numero_proposta
      t.integer :numero_proposta_origem
      t.string  :numero_processo_protocolo_original
      t.string  :especificacao_geral
      t.string  :data_atual

      t.integer :integration_expenses_npf_id

      t.timestamps
    end

    add_index :integration_expenses_neds, [:exercicio, :unidade_gestora, :numero], unique: true, name: "index_exercicio_unidade_gestora_numero_on_neds"
    add_index :integration_expenses_neds, :integration_expenses_npf_id, name: "index_expenses_npfs_on_integration_expenses_npf_id"
  end
end
