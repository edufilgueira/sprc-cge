class CreateIntegrationExpensesConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_expenses_configurations do |t|
      t.string :npf_wsdl
      t.string :npf_headers_soap_action
      t.string :npf_operation
      t.string :npf_response_path
      t.string :npf_user
      t.string :npf_password
      t.string :ned_wsdl
      t.string :ned_headers_soap_action
      t.string :ned_operation
      t.string :ned_response_path
      t.string :ned_user
      t.string :ned_password
      t.string :nld_wsdl
      t.string :nld_headers_soap_action
      t.string :nld_operation
      t.string :nld_response_path
      t.string :nld_user
      t.string :nld_password
      t.string :npd_wsdl
      t.string :npd_headers_soap_action
      t.string :npd_operation
      t.string :npd_response_path
      t.string :npd_user
      t.string :npd_password
      t.datetime :last_importation
      t.text :log
      t.integer :status

      t.timestamps
    end
  end
end
