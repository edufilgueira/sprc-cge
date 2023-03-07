class CreateIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_organs do |t|
      t.string :codigo_orgao, index: true
      t.string :descricao_orgao
      t.string :sigla
      t.string :codigo_entidade
      t.string :descricao_entidade
      t.string :descricao_administracao
      t.string :poder
      t.string :codigo_folha_pagamento

      t.timestamps
    end
  end
end
