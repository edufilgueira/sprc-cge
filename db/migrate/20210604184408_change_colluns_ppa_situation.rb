class ChangeCollunsPPASituation < ActiveRecord::Migration[5.0]
  def up
    
    remove_column :ppa_situations, :isn_solucao
    add_column :ppa_situations, :isn_solucao, :integer
    

  end

  def down
    
    remove_column :ppa_situations, :isn_solucao
    add_column :ppa_situations, :isn_solucao, :string

  end
end
