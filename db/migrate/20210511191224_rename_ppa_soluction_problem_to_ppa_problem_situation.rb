class RenamePPASoluctionProblemToPPAProblemSituation < ActiveRecord::Migration[5.0]
  def up
  	rename_table :ppa_soluction_problems, :ppa_problem_situations
  end
  
  def down
  	rename_table :ppa_problem_situations, :ppa_soluction_problems
  end
end
