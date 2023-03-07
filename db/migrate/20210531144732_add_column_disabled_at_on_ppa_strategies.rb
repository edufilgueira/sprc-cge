class AddColumnDisabledAtOnPPAStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies, :disabled_at, :datetime
  end
end
