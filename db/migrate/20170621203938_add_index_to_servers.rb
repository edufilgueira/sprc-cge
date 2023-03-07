class AddIndexToServers < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_servers, [:dsc_matricula, :cod_orgao],
      name: 'integration_servers_servers_pk_index'

    add_index :integration_servers_proceeds, [:cod_provento, :num_ano, :num_mes, :cod_orgao, :dsc_matricula],
      name: 'integration_servers_proceeds_pk_index'
  end
end
