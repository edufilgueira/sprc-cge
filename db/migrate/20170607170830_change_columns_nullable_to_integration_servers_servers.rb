class ChangeColumnsNullableToIntegrationServersServers < ActiveRecord::Migration[5.0]

  def up
    remove_column :integration_servers_servers, :cod_orgao
    remove_column :integration_servers_servers, :dsc_cargo
    remove_column :integration_servers_servers, :dth_nascimento
    remove_column :integration_servers_servers, :num_folha
    remove_column :integration_servers_servers, :cod_situacao_funcional
    remove_column :integration_servers_servers, :cod_afastamento
    remove_column :integration_servers_servers, :dth_afastamento
    remove_column :integration_servers_servers, :vlr_carga_horaria
    remove_column :integration_servers_servers, :vdth_admissao


    add_column :integration_servers_servers, :cod_orgao, :string
    add_index :integration_servers_servers, :cod_orgao

    add_column :integration_servers_servers, :dsc_cargo, :string
    add_index :integration_servers_servers, :dsc_cargo

    add_column :integration_servers_servers, :dth_nascimento, :date
    add_column :integration_servers_servers, :num_folha, :string
    add_column :integration_servers_servers, :cod_situacao_funcional, :string
    add_column :integration_servers_servers, :cod_afastamento, :string
    add_column :integration_servers_servers, :dth_afastamento, :date
    add_column :integration_servers_servers, :vlr_carga_horaria, :integer
    add_column :integration_servers_servers, :vdth_admissao, :date
  end

  def down
    remove_column :integration_servers_servers, :cod_orgao
    remove_column :integration_servers_servers, :dsc_cargo
    remove_column :integration_servers_servers, :dth_nascimento
    remove_column :integration_servers_servers, :num_folha
    remove_column :integration_servers_servers, :cod_situacao_funcional
    remove_column :integration_servers_servers, :cod_afastamento
    remove_column :integration_servers_servers, :dth_afastamento
    remove_column :integration_servers_servers, :vlr_carga_horaria
    remove_column :integration_servers_servers, :vdth_admissao


    add_column :integration_servers_servers, :cod_orgao, :string, null: false
    add_index :integration_servers_servers, :cod_orgao

    add_column :integration_servers_servers, :dsc_cargo, :string, null: false
    add_index :integration_servers_servers, :dsc_cargo

    add_column :integration_servers_servers, :dth_nascimento, :date, null: false
    add_column :integration_servers_servers, :num_folha, :string, null: false
    add_column :integration_servers_servers, :cod_situacao_funcional, :string, null: false
    add_column :integration_servers_servers, :cod_afastamento, :string, null: false
    add_column :integration_servers_servers, :dth_afastamento, :date, null: false
    add_column :integration_servers_servers, :vlr_carga_horaria, :integer, null: false
    add_column :integration_servers_servers, :vdth_admissao, :date, null: false
  end

end
