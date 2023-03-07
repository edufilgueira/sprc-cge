class CreatePPASourceThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_source_themes do |t|
      t.string :codigo_tema
      t.string :descricao_tema
      t.string :descricao

      t.timestamps
    end
  end
end
