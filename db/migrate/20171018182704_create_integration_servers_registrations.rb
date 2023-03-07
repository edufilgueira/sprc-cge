class CreateIntegrationServersRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_registrations do |t|
      t.string :dsc_matricula, index: true
      t.string :dsc_cpf
      t.string :dsc_funcionario
      t.string :cod_orgao
      t.string :dsc_cargo
      t.string :num_folha
      t.string :cod_situacao_funcional
      t.string :cod_afastamento
      t.integer :vlr_carga_horaria
      t.date :dth_nascimento
      t.date :dth_afastamento
      t.date :vdth_admissao
      t.integer :organ_id
      t.integer :integration_servers_server_id

      t.timestamps
    end

    add_index :integration_servers_registrations, :organ_id
    add_index :integration_servers_registrations, :integration_servers_server_id, name: "index_servers_registrations_on_servers_server_id"

    add_index :integration_servers_registrations, [:dsc_matricula, :organ_id], name: "integration_servers_registrations_pk_index"
  end
end
