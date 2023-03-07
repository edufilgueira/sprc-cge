class AddReferencesToPPAProblemSituation < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_problem_situations, :theme, foreign_key: { to_table: :ppa_themes }
    add_reference :ppa_problem_situations, :axe, foreign_key: { to_table: :ppa_axes }
    add_reference :ppa_problem_situations, :region, foreign_key: { to_table: :ppa_regions }
    add_reference :ppa_problem_situations, :situation, foreign_key: { to_table: :ppa_situations }

    remove_column :ppa_problem_situations, :isn_solucao, :integer
    remove_column :ppa_problem_situations, :isn_eixo, :integer
    remove_column :ppa_problem_situations, :isn_tema, :integer
    remove_column :ppa_problem_situations, :isn_regiao, :integer
  end
end
