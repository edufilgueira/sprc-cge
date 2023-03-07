class CreatePPASoluction < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_soluctions do |t|
      t.string :description
      t.integer :isn_solucao
      t.timestamps
    end
  end
end
