class CreateIntegrationExpensesNedDisbursementForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_ned_disbursement_forecasts do |t|
      t.string  :data
      t.decimal :valor
      t.integer :integration_expenses_ned_id

      t.timestamps
    end

    add_index :integration_expenses_ned_disbursement_forecasts, :integration_expenses_ned_id, name: "index_expenses_ned_disbursement_forecasts_on_ned_id"

  end
end
