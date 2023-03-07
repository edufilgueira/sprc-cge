class AddColumnDisabledAtOnPPAThemes < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_themes, :disabled_at, :datetime
  end
end
