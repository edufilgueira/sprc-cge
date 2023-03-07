class CreateNewIntegrationServersProceeds < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_proceeds do |t|
      t.integer :num_ano
      t.integer :num_mes
      t.string :cod_processamento
      t.decimal :vlr_financeiro
      t.decimal :vlr_vencimento
      t.datetime :created_at
      t.datetime :updated_at
      t.string :cod_orgao
      t.string :dsc_matricula
      t.string :cod_provento
      t.integer :integration_servers_registration_id
      t.integer :integration_servers_proceed_type_id

      t.timestamps
    end

    add_index :integration_servers_proceeds, :integration_servers_registration_id, name: "index_servers_proceeds_on_servers_registration_id"
    add_index :integration_servers_proceeds, :integration_servers_proceed_type_id, name: "index_servers_proceeds_on_servers_proceed_types_id"

    add_index :integration_servers_proceeds, [:num_mes, :num_ano]
    add_index :integration_servers_proceeds, [:cod_provento, :num_ano, :num_mes, :cod_orgao, :dsc_matricula], name: "integration_servers_proceeds_pk_index"
  end
end
