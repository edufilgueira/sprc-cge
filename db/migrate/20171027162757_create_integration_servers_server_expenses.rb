class CreateIntegrationServersServerExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_server_expenses do |t|
      t.integer :month, null: false
      t.integer :year, null: false
      t.decimal :expense, null: false, precision: 15, scale: 2

      t.timestamps
    end
  end
end
