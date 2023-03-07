class CreateNewIntegrationServersServers < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_servers do |t|
      t.string :dsc_cpf, unique: true, index: true
      t.string :dsc_funcionario, index: true
      t.date :dth_nascimento

      t.timestamps
    end
  end
end
