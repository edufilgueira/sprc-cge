class ChangeIsnSolucaoProblemaToString < ActiveRecord::Migration[5.0]
  def change
    change_column :ppa_problem_situations, :isn_solucao_problema, :string
    
  end

end
