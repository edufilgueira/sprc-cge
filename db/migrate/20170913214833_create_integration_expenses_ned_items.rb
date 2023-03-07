class CreateIntegrationExpensesNedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_ned_items do |t|
      t.integer :sequencial
      t.string  :especificacao
      t.string  :unidade
      t.decimal :quantidade
      t.decimal :valor_unitario
      t.integer :integration_expenses_ned_id

      t.timestamps
    end

    add_index :integration_expenses_ned_items, :integration_expenses_ned_id, name: "index_expenses_ned_items_on_ned_id"

  end
end
