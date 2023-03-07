class CreateIntegrationExpensesNlds < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_nlds do |t|
      t.string :exercicio
      t.string :unidade_gestora
      t.string :unidade_executora
      t.string :numero
      t.string :numero_nld_ordinaria
      t.string :natureza
      t.string :tipo_de_documento_da_despesa
      t.string :numero_do_documento_da_despesa
      t.string :data_do_documento_da_despesa
      t.string :efeito
      t.string :processo_administrativo_despesa
      t.string :data_emissao
      t.decimal :valor
      t.decimal :valor_retido
      t.string :cpf_ordenador_despesa
      t.string :credor
      t.string :numero_npf_ordinaria
      t.string :numero_nota_empenho_despesa
      t.string :tipo_despesa_extra_orcamentaria
      t.string :especificacao_restituicao
      t.string :exercicio_restos_a_pagar
      t.string :data_atual

      t.integer :integration_expenses_ned_id

      t.timestamps
    end

    add_index :integration_expenses_nlds, [:exercicio, :unidade_gestora, :numero], unique: true, name: "index_exercicio_unidade_gestora_numero_on_nlds"
    add_index :integration_expenses_nlds, :integration_expenses_ned_id, name: "index_expenses_neds_on_integration_expenses_ned_id"
  end
end
