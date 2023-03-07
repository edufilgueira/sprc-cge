class CreateIntegrationServersProceeds < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_proceeds do |t|
      t.integer :cod_orgao, null: false
      t.integer :dsc_matricula, null: false
      t.integer :num_ano, null: false
      t.integer :num_mes, null: false
      t.string :cod_processamento, null: false
      t.decimal :vlr_financeiro, null: false, precision: 10, scale: 2
      t.decimal :vlr_vencimento, null: false, precision: 10, scale: 2
      t.integer :cod_provento, null: false

      t.index [:num_ano, :num_mes]

      t.timestamps
    end
  end
end
