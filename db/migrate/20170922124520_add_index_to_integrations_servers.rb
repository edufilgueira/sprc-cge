class AddIndexToIntegrationsServers < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_servers_servers, :cod_situacao_funcional
    add_index :integration_servers_proceed_types, :dsc_tipo
  end
end
