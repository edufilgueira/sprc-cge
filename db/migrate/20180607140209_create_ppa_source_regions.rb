class CreatePPASourceRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_source_regions do |t|
      t.string :codigo_regiao
      t.string :descricao_regiao

      t.timestamps
    end
  end
end
