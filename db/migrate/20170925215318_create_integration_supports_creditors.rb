class CreateIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_creditors do |t|
      t.string :bairro
      t.string :cep
      t.string :codigo, index: true
      t.string :codigo_contribuinte
      t.string :codigo_distrito
      t.string :codigo_municipio
      t.string :codigo_nit
      t.string :codigo_pis_pasep
      t.string :complemento
      t.string :cpf_cnpj
      t.string :data_atual
      t.string :data_cadastro
      t.string :email
      t.string :logradouro
      t.string :nome
      t.string :nome_municipio
      t.string :numero
      t.string :status
      t.string :telefone_contato
      t.string :uf

      t.timestamps
    end
  end
end
