class CreateIntegrationExpensesNedPlanningItems < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_ned_planning_items do |t|
      t.integer :isn_item_parcela
      t.decimal :valor
      t.integer :integration_expenses_ned_id

      t.timestamps
    end

    add_index :integration_expenses_ned_planning_items, :integration_expenses_ned_id, name: "index_expenses_ned_planning_items_on_ned_id"
  end
end
