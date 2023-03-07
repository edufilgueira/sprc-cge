class CreateNewIntegrationServersProceedTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_servers_proceed_types do |t|
      t.string :cod_provento, index: true
      t.string :dsc_tipo, index: true
      t.string :dsc_provento

      t.timestamps
    end
  end
end
