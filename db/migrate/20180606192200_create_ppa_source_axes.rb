class CreatePPASourceAxes < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_source_axes do |t|
      t.string :codigo_eixo
      t.string :descricao_eixo
      t.string :codigo_tema
      t.string :descricao_tema
      t.string :descricao_tema_detalhado

      t.timestamps
    end
  end
end
