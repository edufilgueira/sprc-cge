class CreateIntegrationContractsContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_contracts do |t|
      t.string :cod_concedente
      t.string :cod_financiador
      t.string :cod_gestora
      t.string :cod_orgao
      t.string :cod_secretaria
      t.string :decricao_modalidade
      t.string :descricao_objeto
      t.string :descricao_tipo
      t.string :descricao_url
      t.datetime :data_assinatura
      t.datetime :data_processamento
      t.datetime :data_termino
      t.integer :flg_tipo
      t.integer :isn_parte_destino
      t.integer :isn_sic, index: true
      t.string :num_spu
      t.decimal :valor_contrato
      t.integer :isn_modalidade
      t.integer :isn_entidade
      t.string :tipo_objeto
      t.string :num_spu_licitacao
      t.string :descricao_justificativa
      t.decimal :valor_can_rstpg
      t.datetime :data_publicacao_portal
      t.string :descricao_url_pltrb
      t.string :descricao_url_ddisp
      t.string :descricao_url_inexg
      t.string :cod_plano_trabalho
      t.string :num_certidao
      t.string :descriaco_edital
      t.string :cpf_cnpj_financiador
      t.string :num_contrato
      t.decimal :valor_original_concedente
      t.decimal :valor_original_contrapartida
      t.decimal :valor_atualizado_concedente
      t.decimal :valor_atualizado_contrapartida

      t.timestamps
    end
  end
end
