class AddColumnDisabledAtOnPPAObjectives < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_objectives, :disabled_at, :datetime
  end
end
