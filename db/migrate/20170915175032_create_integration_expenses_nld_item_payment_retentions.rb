class CreateIntegrationExpensesNldItemPaymentRetentions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_nld_item_payment_retentions do |t|
      t.string :codigo_retencao
      t.string :credor
      t.decimal :valor

      t.integer :integration_expenses_nld_id

      t.timestamps
    end

    add_index :integration_expenses_nld_item_payment_retentions, :integration_expenses_nld_id, name: "index_expenses_nld_payment_retentions_on_nld_id"
  end
end
