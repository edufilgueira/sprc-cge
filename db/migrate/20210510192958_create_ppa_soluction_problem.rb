class CreatePPASoluctionProblem < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_soluction_problems do |t|
    	t.string :isn_solucao_problema
      t.string :isn_eixo
      t.string :isn_tema
      t.string :isn_regiao
      t.string :isn_solucao
      t.datetime :dth_registro
      t.timestamps
    
    end
  end
end
