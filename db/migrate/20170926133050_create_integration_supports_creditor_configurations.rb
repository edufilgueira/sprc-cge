class CreateIntegrationSupportsCreditorConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_creditor_configurations do |t|
      t.string :wsdl
      t.string :headers_soap_action
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
