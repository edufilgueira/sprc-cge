class RemovePriorityFromPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_strategies, :priority, :integer
  end
end
