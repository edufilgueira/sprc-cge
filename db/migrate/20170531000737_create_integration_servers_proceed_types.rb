class CreateIntegrationServersProceedTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_proceed_types do |t|
      t.integer :cod_provento, null: false, index: true
      t.string :dsc_provento, null: false
      t.string :dsc_tipo, null: false

      t.timestamps
    end
  end
end
