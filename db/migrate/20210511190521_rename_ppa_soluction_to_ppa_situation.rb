class RenamePPASoluctionToPPASituation < ActiveRecord::Migration[5.0]
  def up
  	rename_table :ppa_soluctions, :ppa_situations
  end
  
  def down
  	rename_table :ppa_situations, :ppa_soluctions
  end
end
