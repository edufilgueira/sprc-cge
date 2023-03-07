class ChangeColumnNameSolucaoProblemaToString < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_problem_situations, :axe_id, :axis_id
  end
end
