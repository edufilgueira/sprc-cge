class ChangePPASoluctionIsnSolucao < ActiveRecord::Migration[5.0]
  def change
  	change_column :ppa_soluctions, :isn_solucao, :string
  end
end
