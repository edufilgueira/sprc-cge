class CreateIntegrationRevenuesAccount < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_revenues_accounts do |t|
      t.string  :conta_corrente
      t.string  :natureza_credito
      t.decimal :valor_credito
      t.string  :natureza_debito
      t.decimal :valor_debito
      t.decimal :valor_inicial
      t.string  :natureza_inicial
      t.string  :mes
      t.integer :integration_revenues_revenue_id

      t.timestamps

    end

    add_index :integration_revenues_accounts, :integration_revenues_revenue_id, name: "index_revenues_on_revenue_id"
    add_index :integration_revenues_accounts, :conta_corrente

  end
end
