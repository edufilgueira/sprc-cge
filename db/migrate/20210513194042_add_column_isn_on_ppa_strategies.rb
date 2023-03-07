class AddColumnIsnOnPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies, :isn, :integer
  end
end
