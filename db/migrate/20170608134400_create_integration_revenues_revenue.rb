class CreateIntegrationRevenuesRevenue < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_revenues_revenues do |t|
      t.string  :unidade
      t.string  :poder
      t.string  :administracao
      t.string  :conta_contabil
      t.string  :titulo
      t.string  :natureza_da_conta
      t.string  :natureza_credito
      t.decimal :valor_credito
      t.string  :natureza_debito
      t.decimal :valor_debito
      t.decimal :valor_inicial
      t.string  :natureza_inicial
      t.string  :fechamento_contabil
      t.string  :data_atual

      t.timestamps
    end
  end
end
