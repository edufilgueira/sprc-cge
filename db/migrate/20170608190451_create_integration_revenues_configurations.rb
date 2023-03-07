class CreateIntegrationRevenuesConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_revenues_configurations do |t|
      t.string :endpoint
      t.string :wsdl
      t.string :user
      t.string :password
      t.string :operation
      t.string :response_path
      t.integer :status
      t.datetime :last_importation
      t.text :log

      t.timestamps
    end
  end
end
