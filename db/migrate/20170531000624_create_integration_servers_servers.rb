class CreateIntegrationServersServers < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_servers do |t|
      t.integer :cod_orgao, null: false , index: true
      t.integer :dsc_matricula, null: false, index: true
      t.string :dsc_funcionario, null: false, index: true
      t.string :dsc_cargo, null: false, index: true
      t.string :dsc_cpf, null: false, index: true
      t.date :dth_nascimento, null: false
      t.integer :num_folha, null: false
      t.string :cod_situacao_funcional, null: false
      t.string :cod_afastamento, null: false
      t.date :dth_afastamento, null: false
      t.integer :vlr_carga_horaria, null: false
      t.string :vdth_admissao, null: false

      t.timestamps
    end
  end
end
