class CreateIntegrationContractsAdditives < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_additives do |t|
      t.string :descricao_observacao
      t.string :descricao_tipo_aditivo
      t.string :descricao_url
      t.datetime :data_aditivo
      t.datetime :data_inicio
      t.datetime :data_publicacao
      t.datetime :data_termino
      t.integer :flg_tipo_aditivo
      t.integer :isn_contrato_aditivo
      t.integer :isn_ig
      t.integer :isn_sic
      t.decimal :valor_acrescimo
      t.decimal :valor_reducao
      t.datetime :data_publicacao_portal
      t.string :num_aditivo_siconv
      t.integer :integration_contracts_contract_id

      t.timestamps
    end

    add_index :integration_contracts_additives, :integration_contracts_contract_id, name: "index_contracts_additives_on_revenue_id"
  end
end
