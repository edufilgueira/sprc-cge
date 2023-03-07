class ChangeColumnsTypeToIntegrationServers < ActiveRecord::Migration[5.0]
  def up
    remove_column :integration_servers_servers, :cod_orgao
    remove_column :integration_servers_servers, :dsc_matricula
    remove_column :integration_servers_servers, :num_folha
    remove_column :integration_servers_servers, :vdth_admissao

    remove_column :integration_servers_proceeds, :cod_orgao
    remove_column :integration_servers_proceeds, :dsc_matricula
    remove_column :integration_servers_proceeds, :cod_provento

    remove_column :integration_servers_proceed_types, :cod_provento


    add_column :integration_servers_servers, :cod_orgao, :string, null: false
    add_index :integration_servers_servers, :cod_orgao
    add_column :integration_servers_servers, :dsc_matricula, :string, null: false
    add_index :integration_servers_servers, :dsc_matricula
    add_column :integration_servers_servers, :num_folha, :string, null: false
    add_column :integration_servers_servers, :vdth_admissao, :date, null: false

    add_column :integration_servers_proceeds, :cod_orgao, :string, null: false
    add_column :integration_servers_proceeds, :dsc_matricula, :string, null: false
    add_column :integration_servers_proceeds, :cod_provento, :string, null: false

    add_column :integration_servers_proceed_types, :cod_provento, :string, null: false
    add_index :integration_servers_proceed_types, :cod_provento
  end

  def down
    remove_column :integration_servers_servers, :cod_orgao
    remove_column :integration_servers_servers, :dsc_matricula
    remove_column :integration_servers_servers, :num_folha
    remove_column :integration_servers_servers, :vdth_admissao

    remove_column :integration_servers_proceeds, :cod_orgao
    remove_column :integration_servers_proceeds, :dsc_matricula
    remove_column :integration_servers_proceeds, :cod_provento

    remove_column :integration_servers_proceed_types, :cod_provento


    add_column :integration_servers_servers, :cod_orgao, :integer, null: false
    add_index :integration_servers_servers, :cod_orgao
    add_column :integration_servers_servers, :dsc_matricula, :integer, null: false
    add_index :integration_servers_servers, :dsc_matricula
    add_column :integration_servers_servers, :num_folha, :integer, null: false
    add_column :integration_servers_servers, :vdth_admissao, :string, null: false

    add_column :integration_servers_proceeds, :cod_orgao, :integer, null: false
    add_column :integration_servers_proceeds, :dsc_matricula, :integer, null: false
    add_column :integration_servers_proceeds, :cod_provento, :integer, null: false

    add_column :integration_servers_proceed_types, :cod_provento, :integer, null: false
    add_index :integration_servers_proceed_types, :cod_provento
  end
end
