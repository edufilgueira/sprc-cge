class RenamePriorizationToPriorityOnPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    # Não dá pra trocar de tipo String pra Integer de maneira fácil.
    # Como não temos dados na tabela ainda, vamos com DROP + ADD.
    # Veja que também estamos renomeando a coluna :priorization => :priority
    remove_column :ppa_strategies, :priorization, :string
    add_column :ppa_strategies, :priority, :integer
  end
end
