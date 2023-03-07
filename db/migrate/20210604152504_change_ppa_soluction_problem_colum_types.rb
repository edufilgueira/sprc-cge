class ChangePPASoluctionProblemColumTypes < ActiveRecord::Migration[5.0]
  def up
    remove_column :ppa_problem_situations, :isn_solucao_problema
    remove_column :ppa_problem_situations, :isn_eixo
    remove_column :ppa_problem_situations, :isn_tema
    remove_column :ppa_problem_situations, :isn_regiao
    remove_column :ppa_problem_situations, :isn_solucao

    add_column :ppa_problem_situations, :isn_solucao_problema, :integer
    add_column :ppa_problem_situations, :isn_eixo, :integer
    add_column :ppa_problem_situations, :isn_tema, :integer
    add_column :ppa_problem_situations, :isn_regiao, :integer
    add_column :ppa_problem_situations, :isn_solucao, :integer
  end

  def down
    remove_column :ppa_problem_situations, :isn_solucao_problema
    remove_column :ppa_problem_situations, :isn_eixo
    remove_column :ppa_problem_situations, :isn_tema
    remove_column :ppa_problem_situations, :isn_regiao
    remove_column :ppa_problem_situations, :isn_solucao

    add_column :ppa_problem_situations, :isn_solucao_problema, :string
    add_column :ppa_problem_situations, :isn_eixo, :string
    add_column :ppa_problem_situations, :isn_tema, :string
    add_column :ppa_problem_situations, :isn_regiao, :string
    add_column :ppa_problem_situations, :isn_solucao, :string
  end
end

