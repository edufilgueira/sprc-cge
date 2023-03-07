class CreateIntegrationRevenuesAccountConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_revenues_account_configurations do |t|
      t.string :account_number
      t.string :title
      t.integer :integration_revenues_configuration_id

      t.timestamps
    end

    add_index :integration_revenues_account_configurations, :integration_revenues_configuration_id, name: "index_revenues_on_configuration_id"
  end
end
