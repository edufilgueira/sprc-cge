class CreateIntegrationExpensesNldItemPaymentPlannings < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_nld_item_payment_plannings do |t|
      t.integer :codigo_isn
      t.decimal :valor_liquidado

      t.integer :integration_expenses_nld_id

      t.timestamps
    end

    add_index :integration_expenses_nld_item_payment_plannings, :integration_expenses_nld_id, name: "index_expenses_nld_payment_planning_on_nld_id"
  end
end
