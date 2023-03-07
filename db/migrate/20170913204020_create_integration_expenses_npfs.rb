class CreateIntegrationExpensesNpfs < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_npfs do |t|
      t.integer :exercicio
      t.string  :unidade_gestora
      t.string  :unidade_executora
      t.string  :numero
      t.string  :numero_npf_ord
      t.string  :natureza
      t.string  :tipo_proc_adm_desp
      t.string  :efeito
      t.string  :data_emissao
      t.string  :grupo_fin
      t.string  :fonte_rec
      t.decimal :valor
      t.string  :credor
      t.string  :codigo_projeto
      t.string  :numero_parcela
      t.string  :isn_parcela
      t.string  :numeroconvenio
      t.string  :data_atual

      t.timestamps
    end

    add_index :integration_expenses_npfs, [:exercicio, :unidade_gestora, :numero], unique: true, name: "index_exercicio_unidade_gestora_numero_on_npfs"
  end
end
