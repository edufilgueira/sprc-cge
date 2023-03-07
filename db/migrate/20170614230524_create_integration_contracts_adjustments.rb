class CreateIntegrationContractsAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_adjustments do |t|
      t.string :descricao_observacao
      t.string :descricao_tipo_ajuste
      t.datetime :data_ajuste
      t.datetime :data_alteracao
      t.datetime :data_exclusao
      t.datetime :data_inclusao
      t.datetime :data_inicio
      t.datetime :data_termino
      t.integer :flg_acrescimo_reducao
      t.integer :flg_controle_transmissao
      t.integer :flg_receita_despesa
      t.integer :flg_tipo_ajuste
      t.integer :isn_contrato_ajuste
      t.integer :isn_contrato_tipo_ajuste
      t.integer :ins_edital
      t.integer :isn_sic
      t.integer :isn_situacao
      t.integer :isn_usuario_alteracao
      t.integer :isn_usuario_aprovacao
      t.integer :isn_usuario_auditoria
      t.integer :isn_usuario_exclusao
      t.decimal :valor_ajuste_destino
      t.decimal :valor_ajuste_origem
      t.decimal :valor_inicio_destino
      t.decimal :valor_inicio_origem
      t.decimal :valor_termino_origem
      t.decimal :valor_termino_destino
      t.string :descricao_url
      t.string :num_apostilamento_siconv
      t.integer :integration_contracts_contract_id

      t.timestamps
    end

    add_index :integration_contracts_adjustments, :integration_contracts_contract_id, name: "index_contracts_adjustments_on_revenue_id"
  end
end
